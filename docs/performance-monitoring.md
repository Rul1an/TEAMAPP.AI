# Performance Monitoring Guide

## Overview

This document outlines the performance monitoring infrastructure implemented in the JO17 Tactical Manager application. The system provides comprehensive monitoring across web builds with real-user metrics, memory leak detection, and automated performance gates.

## Architecture

### 1. Memory Leak Detection

**Location**: `test/memory/leak_tracker_test.dart`

The application uses `leak_tracker_flutter_testing` to detect memory leaks during development and CI:

```bash
# Run memory leak detection
flutter test test/memory/ --dart-define=LEAK_TRACKER_ENABLED=true
```

**Configuration**:
- Enabled in CI via `.github/workflows/advanced-deployment.yml`
- Configured in `.dart_code_metrics.yaml` with memory-leak rule

### 2. Web Vitals Monitoring

**Location**: `web/index.html` (web-vitals polyfill)

Real User Monitoring (RUM) is implemented using the web-vitals polyfill:

```javascript
// Core Web Vitals tracked:
// - LCP (Largest Contentful Paint)
// - FID (First Input Delay)
// - CLS (Cumulative Layout Shift)
// - FCP (First Contentful Paint)
// - TTFB (Time to First Byte)
```

**Data Flow**:
1. Web-vitals polyfill captures metrics
2. Data sent to `/api/web-vitals` endpoint
3. Firebase Performance Monitoring processes data
4. Analytics dashboard displays trends

### 3. Performance Tracking

**Location**: `lib/services/performance_tracker.dart`

The `PerformanceTracker` service provides:
- Route transition timing
- Widget build performance
- Custom metric tracking
- Integration with Firebase Performance

### 4. Error Boundaries & Sentry

**Location**: `lib/widgets/error_boundary.dart`

Global error handling with Sentry integration:
- Automatic crash reporting
- Performance tracing
- User context tracking
- Release tracking

## CI/CD Integration

### Memory Leak Detection

```yaml
# .github/workflows/advanced-deployment.yml
- name: 🧠 Memory Leak Detection
  run: |
    flutter test test/memory/ --dart-define=LEAK_TRACKER_ENABLED=true
```

### Lighthouse Performance Gates

```yaml
# Performance thresholds:
- Performance Score: ≥85%
- Accessibility Score: ≥90%
- Best Practices Score: ≥80%
- SEO Score: ≥80%
- FCP: ≤2000ms
- LCP: ≤2500ms
- CLS: ≤0.1
- TBT: ≤300ms
```

## Monitoring Dashboard

### Firebase Performance Monitoring

Access the dashboard at: [Firebase Console](https://console.firebase.google.com)

**Key Metrics**:
- Page load times
- Route transition performance
- Custom traces
- Error rates

### Web Vitals Dashboard

Real-time Core Web Vitals data available in:
- Firebase Performance Monitoring
- Google Analytics (if configured)
- Custom analytics dashboard

## Troubleshooting

### Memory Leaks

1. **Check CI logs** for memory leak detection failures
2. **Run locally**: `flutter test test/memory/`
3. **Review code** for common patterns:
   - Unclosed streams/controllers
   - Circular references
   - Large object retention

### Performance Issues

1. **Check Lighthouse report** in CI logs
2. **Review web-vitals data** in Firebase
3. **Analyze PerformanceTracker logs**
4. **Check Sentry** for performance traces

### Web Vitals Failures

1. **Verify endpoint**: `/api/web-vitals`
2. **Check data format** in `test/web_vitals_flow_test.dart`
3. **Review Firebase configuration**
4. **Validate polyfill loading**

## Best Practices

### Development

1. **Run memory tests** before committing
2. **Monitor web-vitals** during development
3. **Use PerformanceTracker** for custom metrics
4. **Test performance gates** locally

### Production

1. **Monitor Firebase Performance** regularly
2. **Review Lighthouse reports** after deployments
3. **Track error rates** in Sentry
4. **Analyze user experience** metrics

## Configuration

### Environment Variables

```bash
# Memory leak detection
LEAK_TRACKER_ENABLED=true

# Performance monitoring
FIREBASE_PERFORMANCE_ENABLED=true
SENTRY_DSN=your-sentry-dsn
```

### Dependencies

```yaml
# pubspec.yaml
dependencies:
  firebase_performance: ^0.9.3+8
  sentry_flutter: ^7.16.1

dev_dependencies:
  leak_tracker_flutter_testing: ^1.0.0
  dart_code_metrics: ^5.7.6
```

## Maintenance

### Regular Tasks

1. **Update dependencies** monthly
2. **Review performance thresholds** quarterly
3. **Analyze memory leak patterns** weekly
4. **Monitor web-vitals trends** daily

### Alerts

- Performance score drops below 85%
- Memory leaks detected in CI
- Web-vitals endpoint failures
- Sentry error rate spikes

## Support

For issues with performance monitoring:

1. Check this documentation
2. Review CI logs
3. Consult Firebase/Sentry dashboards
4. Contact the development team
