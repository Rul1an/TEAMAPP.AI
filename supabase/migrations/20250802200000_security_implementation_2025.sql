-- Security Implementation 2025: Advanced Rate Limiting & Monitoring
-- Migration Date: 2025-08-02
-- Purpose: Implement production-ready security features

-- ================================================================
-- 1. SECURITY AUDIT & REQUEST LOGGING TABLES
-- ================================================================

-- Security events logging
CREATE TABLE IF NOT EXISTS security_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  event_type TEXT NOT NULL,
  source_ip INET,
  user_id UUID REFERENCES auth.users(id),
  severity TEXT CHECK (severity IN ('low', 'medium', 'high', 'critical')) DEFAULT 'medium',
  details JSONB DEFAULT '{}',
  geo_country TEXT,
  user_agent TEXT,
  endpoint TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  resolved_at TIMESTAMPTZ,
  status TEXT CHECK (status IN ('new', 'investigating', 'resolved', 'false_positive')) DEFAULT 'new'
);

-- Request logs for rate limiting
CREATE TABLE IF NOT EXISTS request_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  ip_address INET NOT NULL,
  endpoint TEXT NOT NULL,
  method TEXT NOT NULL,
  status_code INTEGER,
  response_time_ms INTEGER,
  user_agent TEXT,
  geo_country TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Security alerts
CREATE TABLE IF NOT EXISTS security_alerts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  alert_type TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  severity TEXT CHECK (severity IN ('low', 'medium', 'high', 'critical')) DEFAULT 'medium',
  details JSONB DEFAULT '{}',
  status TEXT CHECK (status IN ('open', 'acknowledged', 'resolved')) DEFAULT 'open',
  assigned_to UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  resolved_at TIMESTAMPTZ
);

-- User risk scores
ALTER TABLE auth.users
ADD COLUMN IF NOT EXISTS risk_score INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS last_security_audit TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS device_fingerprint TEXT,
ADD COLUMN IF NOT EXISTS security_level TEXT CHECK (security_level IN ('basic', 'elevated', 'admin', 'system')) DEFAULT 'basic';

-- ================================================================
-- 2. ADVANCED RATE LIMITING FUNCTIONS
-- ================================================================

-- Enhanced rate limiting with user risk assessment
CREATE OR REPLACE FUNCTION check_advanced_rate_limit(
  p_user_id UUID DEFAULT NULL,
  p_ip_address INET DEFAULT NULL,
  p_endpoint TEXT DEFAULT 'general',
  p_max_requests INTEGER DEFAULT 100,
  p_window_seconds INTEGER DEFAULT 3600
) RETURNS BOOLEAN AS $$
DECLARE
  request_count INTEGER := 0;
  user_risk INTEGER := 0;
  adjusted_limit INTEGER;
  is_suspicious BOOLEAN := FALSE;
BEGIN
  -- Get user risk score
  IF p_user_id IS NOT NULL THEN
    SELECT COALESCE(risk_score, 0) INTO user_risk
    FROM auth.users
    WHERE id = p_user_id;
  END IF;

  -- Adjust limits based on risk score
  adjusted_limit := CASE
    WHEN user_risk > 75 THEN p_max_requests * 0.2  -- High risk: 80% reduction
    WHEN user_risk > 50 THEN p_max_requests * 0.5  -- Medium risk: 50% reduction
    WHEN user_risk > 25 THEN p_max_requests * 0.8  -- Low risk: 20% reduction
    ELSE p_max_requests                             -- Normal: full limits
  END;

  -- Count recent requests
  SELECT COUNT(*) INTO request_count
  FROM request_logs
  WHERE
    (p_user_id IS NULL OR user_id = p_user_id)
    AND (p_ip_address IS NULL OR ip_address = p_ip_address)
    AND endpoint = p_endpoint
    AND created_at > NOW() - INTERVAL '1 second' * p_window_seconds;

  -- Check for suspicious patterns
  SELECT EXISTS(
    SELECT 1 FROM request_logs
    WHERE ip_address = p_ip_address
      AND created_at > NOW() - INTERVAL '5 minutes'
      AND status_code IN (400, 401, 403, 404, 429)
    HAVING COUNT(*) > 10
  ) INTO is_suspicious;

  -- Log this request
  INSERT INTO request_logs (user_id, ip_address, endpoint, method, created_at)
  VALUES (p_user_id, p_ip_address, p_endpoint, 'CHECK', NOW());

  -- If suspicious, create security event
  IF is_suspicious OR request_count >= adjusted_limit THEN
    INSERT INTO security_events (
      event_type,
      source_ip,
      user_id,
      severity,
      endpoint,
      details
    ) VALUES (
      CASE WHEN is_suspicious THEN 'suspicious_activity' ELSE 'rate_limit_exceeded' END,
      p_ip_address,
      p_user_id,
      CASE WHEN is_suspicious THEN 'high' ELSE 'medium' END,
      p_endpoint,
      jsonb_build_object(
        'request_count', request_count,
        'limit', adjusted_limit,
        'user_risk', user_risk,
        'is_suspicious', is_suspicious
      )
    );
  END IF;

  RETURN request_count < adjusted_limit AND NOT is_suspicious;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ================================================================
-- 3. SECURITY PATTERN DETECTION
-- ================================================================

-- Function to detect malicious patterns
CREATE OR REPLACE FUNCTION detect_security_threats(
  p_input_text TEXT,
  p_source_ip INET DEFAULT NULL,
  p_user_id UUID DEFAULT NULL
) RETURNS BOOLEAN AS $$
DECLARE
  threat_detected BOOLEAN := FALSE;
  threat_type TEXT;
BEGIN
  -- SQL Injection patterns
  IF p_input_text ~* '(union|select|insert|delete|update|drop|create|alter)\s+(select|from|where|into)' THEN
    threat_detected := TRUE;
    threat_type := 'sql_injection';
  END IF;

  -- XSS patterns
  IF p_input_text ~* '<script[^>]*>|javascript:|onerror=|onload=' THEN
    threat_detected := TRUE;
    threat_type := 'xss_attempt';
  END IF;

  -- Path traversal
  IF p_input_text ~* '\.\./|\.\.\\'  THEN
    threat_detected := TRUE;
    threat_type := 'path_traversal';
  END IF;

  -- Command injection
  IF p_input_text ~* '(\||&|;|\$\(|\`)'  THEN
    threat_detected := TRUE;
    threat_type := 'command_injection';
  END IF;

  -- Log threat if detected
  IF threat_detected THEN
    INSERT INTO security_events (
      event_type,
      source_ip,
      user_id,
      severity,
      details
    ) VALUES (
      threat_type,
      p_source_ip,
      p_user_id,
      'critical',
      jsonb_build_object(
        'malicious_input', LEFT(p_input_text, 500),
        'pattern_type', threat_type,
        'detected_at', NOW()
      )
    );
  END IF;

  RETURN NOT threat_detected;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ================================================================
-- 4. USER RISK CALCULATION
-- ================================================================

-- Calculate user risk score based on behavior
CREATE OR REPLACE FUNCTION calculate_user_risk_score(p_user_id UUID)
RETURNS INTEGER AS $$
DECLARE
  risk_score INTEGER := 0;
  failed_attempts INTEGER;
  unusual_locations INTEGER;
  security_violations INTEGER;
  recent_activity INTEGER;
BEGIN
  -- Failed login attempts (last 24 hours)
  SELECT COUNT(*) INTO failed_attempts
  FROM request_logs
  WHERE user_id = p_user_id
    AND endpoint LIKE '%auth%'
    AND status_code IN (401, 403)
    AND created_at > NOW() - INTERVAL '24 hours';

  risk_score := risk_score + (failed_attempts * 10);

  -- Unusual geographic locations (last 7 days)
  SELECT COUNT(DISTINCT geo_country) INTO unusual_locations
  FROM request_logs
  WHERE user_id = p_user_id
    AND created_at > NOW() - INTERVAL '7 days'
    AND geo_country IS NOT NULL;

  IF unusual_locations > 3 THEN
    risk_score := risk_score + 25;
  END IF;

  -- Security violations (last 30 days)
  SELECT COUNT(*) INTO security_violations
  FROM security_events
  WHERE user_id = p_user_id
    AND severity IN ('high', 'critical')
    AND created_at > NOW() - INTERVAL '30 days';

  risk_score := risk_score + (security_violations * 20);

  -- Excessive activity patterns
  SELECT COUNT(*) INTO recent_activity
  FROM request_logs
  WHERE user_id = p_user_id
    AND created_at > NOW() - INTERVAL '1 hour';

  IF recent_activity > 500 THEN
    risk_score := risk_score + 30;
  END IF;

  -- Cap risk score at 100
  risk_score := LEAST(risk_score, 100);

  -- Update user record
  UPDATE auth.users
  SET risk_score = calculate_user_risk_score.risk_score,
      last_security_audit = NOW()
  WHERE id = p_user_id;

  RETURN risk_score;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ================================================================
-- 5. ENHANCED RLS POLICIES WITH SECURITY
-- ================================================================

-- Enable RLS on security tables
ALTER TABLE security_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE request_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE security_alerts ENABLE ROW LEVEL SECURITY;

-- Security events: only admins and system can view
CREATE POLICY "security_events_admin_access" ON security_events
FOR ALL USING (
  EXISTS(
    SELECT 1 FROM auth.users
    WHERE id = auth.uid()
    AND security_level IN ('admin', 'system')
  )
);

-- Request logs: users can only see their own
CREATE POLICY "request_logs_user_access" ON request_logs
FOR SELECT USING (
  user_id = auth.uid() OR
  EXISTS(
    SELECT 1 FROM auth.users
    WHERE id = auth.uid()
    AND security_level IN ('admin', 'system')
  )
);

-- Security alerts: admins only
CREATE POLICY "security_alerts_admin_access" ON security_alerts
FOR ALL USING (
  EXISTS(
    SELECT 1 FROM auth.users
    WHERE id = auth.uid()
    AND security_level IN ('admin', 'system')
  )
);

-- Apply security checks to existing tables
CREATE POLICY "players_secure_access" ON players
FOR ALL USING (
  check_advanced_rate_limit(auth.uid(), NULL, 'players_access', 50, 3600) AND
  (COALESCE((SELECT risk_score FROM auth.users WHERE id = auth.uid()), 0) < 75)
);

CREATE POLICY "training_sessions_secure_access" ON training_sessions
FOR ALL USING (
  check_advanced_rate_limit(auth.uid(), NULL, 'training_sessions_access', 100, 3600) AND
  (COALESCE((SELECT risk_score FROM auth.users WHERE id = auth.uid()), 0) < 75)
);

CREATE POLICY "videos_secure_access" ON videos
FOR ALL USING (
  check_advanced_rate_limit(auth.uid(), NULL, 'videos_access', 30, 3600) AND
  (COALESCE((SELECT risk_score FROM auth.users WHERE id = auth.uid()), 0) < 75)
);

-- ================================================================
-- 6. SECURITY MONITORING FUNCTIONS
-- ================================================================

-- Real-time threat monitoring
CREATE OR REPLACE FUNCTION monitor_security_threats()
RETURNS TABLE(
  threat_count INTEGER,
  critical_alerts INTEGER,
  high_risk_users INTEGER,
  suspicious_ips INET[]
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    (SELECT COUNT(*)::INTEGER FROM security_events WHERE created_at > NOW() - INTERVAL '1 hour'),
    (SELECT COUNT(*)::INTEGER FROM security_events WHERE severity = 'critical' AND created_at > NOW() - INTERVAL '24 hours'),
    (SELECT COUNT(*)::INTEGER FROM auth.users WHERE risk_score > 75),
    (SELECT ARRAY_AGG(DISTINCT source_ip) FROM security_events WHERE created_at > NOW() - INTERVAL '1 hour' AND severity IN ('high', 'critical'));
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Generate security report
CREATE OR REPLACE FUNCTION generate_security_report(p_hours INTEGER DEFAULT 24)
RETURNS JSONB AS $$
DECLARE
  report JSONB;
BEGIN
  SELECT jsonb_build_object(
    'report_generated', NOW(),
    'period_hours', p_hours,
    'total_events', (SELECT COUNT(*) FROM security_events WHERE created_at > NOW() - INTERVAL '1 hour' * p_hours),
    'critical_events', (SELECT COUNT(*) FROM security_events WHERE severity = 'critical' AND created_at > NOW() - INTERVAL '1 hour' * p_hours),
    'high_risk_users', (SELECT COUNT(*) FROM auth.users WHERE risk_score > 50),
    'top_threat_types', (
      SELECT jsonb_agg(jsonb_build_object('type', event_type, 'count', count))
      FROM (
        SELECT event_type, COUNT(*) as count
        FROM security_events
        WHERE created_at > NOW() - INTERVAL '1 hour' * p_hours
        GROUP BY event_type
        ORDER BY count DESC
        LIMIT 10
      ) t
    ),
    'geographic_threats', (
      SELECT jsonb_agg(jsonb_build_object('country', geo_country, 'count', count))
      FROM (
        SELECT geo_country, COUNT(*) as count
        FROM security_events
        WHERE created_at > NOW() - INTERVAL '1 hour' * p_hours
          AND geo_country IS NOT NULL
        GROUP BY geo_country
        ORDER BY count DESC
        LIMIT 10
      ) t
    )
  ) INTO report;

  RETURN report;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ================================================================
-- 7. INDEXES FOR PERFORMANCE
-- ================================================================

-- Security events indexes
CREATE INDEX IF NOT EXISTS idx_security_events_created_at ON security_events(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_security_events_severity ON security_events(severity);
CREATE INDEX IF NOT EXISTS idx_security_events_source_ip ON security_events(source_ip);
CREATE INDEX IF NOT EXISTS idx_security_events_user_id ON security_events(user_id);

-- Request logs indexes
CREATE INDEX IF NOT EXISTS idx_request_logs_created_at ON request_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_request_logs_ip_address ON request_logs(ip_address);
CREATE INDEX IF NOT EXISTS idx_request_logs_user_id ON request_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_request_logs_endpoint ON request_logs(endpoint);

-- Composite indexes for rate limiting
CREATE INDEX IF NOT EXISTS idx_request_logs_rate_limit ON request_logs(user_id, endpoint, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_request_logs_ip_rate_limit ON request_logs(ip_address, endpoint, created_at DESC);

-- ================================================================
-- 8. SECURITY MAINTENANCE
-- ================================================================

-- Cleanup old logs (retention policy)
CREATE OR REPLACE FUNCTION cleanup_security_logs()
RETURNS INTEGER AS $$
DECLARE
  deleted_count INTEGER;
BEGIN
  -- Keep request logs for 30 days
  DELETE FROM request_logs
  WHERE created_at < NOW() - INTERVAL '30 days';

  GET DIAGNOSTICS deleted_count = ROW_COUNT;

  -- Keep resolved security events for 90 days
  DELETE FROM security_events
  WHERE status = 'resolved'
    AND resolved_at < NOW() - INTERVAL '90 days';

  -- Log cleanup activity
  INSERT INTO security_events (
    event_type,
    severity,
    details
  ) VALUES (
    'log_cleanup',
    'low',
    jsonb_build_object(
      'deleted_request_logs', deleted_count,
      'cleanup_date', NOW()
    )
  );

  RETURN deleted_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ================================================================
-- 9. GRANTS AND PERMISSIONS
-- ================================================================

-- Grant access to authenticated users for rate limiting checks
GRANT EXECUTE ON FUNCTION check_advanced_rate_limit TO authenticated;
GRANT EXECUTE ON FUNCTION detect_security_threats TO authenticated;
GRANT EXECUTE ON FUNCTION calculate_user_risk_score TO authenticated;

-- Grant monitoring access to service role
GRANT EXECUTE ON FUNCTION monitor_security_threats TO service_role;
GRANT EXECUTE ON FUNCTION generate_security_report TO service_role;
GRANT EXECUTE ON FUNCTION cleanup_security_logs TO service_role;

-- Insert initial security configuration
INSERT INTO security_events (event_type, severity, details)
VALUES (
  'security_system_initialized',
  'low',
  jsonb_build_object(
    'version', '2025.1',
    'features', ARRAY['rate_limiting', 'threat_detection', 'risk_scoring', 'monitoring'],
    'initialized_at', NOW()
  )
);

COMMENT ON TABLE security_events IS 'Centralized security event logging for threat monitoring and audit trails';
COMMENT ON TABLE request_logs IS 'Request logging for rate limiting and security analysis';
COMMENT ON TABLE security_alerts IS 'Active security alerts requiring attention';
COMMENT ON FUNCTION check_advanced_rate_limit IS 'Advanced rate limiting with user risk assessment';
COMMENT ON FUNCTION detect_security_threats IS 'Pattern-based security threat detection';
COMMENT ON FUNCTION calculate_user_risk_score IS 'Dynamic user risk scoring based on behavior';
