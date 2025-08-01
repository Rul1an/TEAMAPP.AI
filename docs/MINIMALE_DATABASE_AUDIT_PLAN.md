# Minimale Database Audit Plan - JO17 Tactical Manager

**Target:** Flutter Web + Supabase Multi-tenant SaaS
**Environment:** ohdbsujaetmrztseqana.supabase.co
**Testing Method:** Browser-only (geen Android/iOS)
**Total Time:** ~6-8 uur (verspreid over meerdere dagen)

---

## ⚡ Quick Start Checklist (30 minuten)

### Voorbereiding
- [ ] **Test accounts aanmaken**: Maak minimaal 3 test accounts in verschillende organisaties
- [ ] **Browser tools activeren**: Chrome DevTools, Network tab, Console tab
- [ ] **OWASP ZAP installeren**: Download van https://www.zaproxy.org/ (gratis)
- [ ] **Credentials documenten**: Noteer alle test login credentials veilig

### Kritieke Snelle Checks
- [ ] **Magic link expiry**: Test of magic links na 1x gebruik nog werken
- [ ] **Session timeout**: Log in, wacht 30 min, refresh → moet uitloggen
- [ ] **Cross-org data leak**: Probeer URL parameter `organization_id` te wijzigen
- [ ] **Console errors**: Check browser console voor credential/token leaks

---

## 🏠 Lokale Testing (2-3 uur)

### Stap 1: Authenticatie & Sessie Management (45 min)

#### 1.1 Magic Link Security
```bash
# Test procedure:
1. Vraag magic link aan
2. Open link in browser
3. Kopieer link → probeer opnieuw te gebruiken (moet falen)
4. Wacht 10 minuten → probeer link opnieuw (moet expiren)
```

**✅ Verwacht resultaat**: Link werkt slechts 1x, expireert binnen 10 min

#### 1.2 Session Cookie Analyse
```javascript
// In browser console:
document.cookie.split(';').forEach(c => console.log(c.trim()));

// Check voor:
// - HttpOnly flag (niet zichtbaar in JS)
// - Secure flag (alleen HTTPS)
// - SameSite=Strict/Lax
```

**✅ Verwacht resultaat**: Session cookies hebben security flags

#### 1.3 Multi-Factor Authentication
```bash
# Test als MFA actief is:
1. Log in met email
2. Onderbreek 2FA proces (sluit browser tab)
3. Probeer direct naar app te navigeren
4. Test 2FA bypass via cookie manipulatie
```

**✅ Verwacht resultaat**: Geen toegang zonder complete 2FA

### Stap 2: Multi-Tenant Isolatie (60 min)

#### 2.1 Organization ID Manipulation
```bash
# Test procedure per browser tab:
Tab 1: Log in als user van Organization A
Tab 2: Log in als user van Organization B

# In Tab 1 DevTools Network:
1. Ga naar Players overzicht
2. Kopieer API request URL
3. Wijzig organization_id parameter naar Organization B
4. Herhaal request
```

**✅ Verwacht resultaat**: 403 Forbidden of empty result

#### 2.2 Direct Object Reference (IDOR)
```bash
# Test URLs zoals:
/api/players/123 → /api/players/124
/api/videos/abc → /api/videos/xyz
/api/training-sessions/456 → /api/training-sessions/457

# Probeer systematisch ID's van andere organisaties
```

**✅ Verwacht resultaat**: Geen toegang tot andere org data

#### 2.3 RLS Policy Verification
```sql
-- Test deze Supabase queries handmatig in SQL Editor:
SELECT * FROM players WHERE organization_id != 'current_user_org';
SELECT * FROM training_sessions WHERE organization_id != 'current_user_org';
SELECT * FROM videos WHERE organization_id != 'current_user_org';
```

**✅ Verwacht resultaat**: Lege resultaten door RLS policies

### Stap 3: Input Validatie & Injection (45 min)

#### 3.1 Basic SQL Injection Test
```bash
# Test in search/filter velden:
' OR '1'='1
'; DROP TABLE players; --
" UNION SELECT * FROM auth.users --

# Formulier velden te testen:
- Player name search
- Training session filters
- Video title search
- Analytics date ranges
```

**✅ Verwacht resultaat**: Geen database errors, gefilterde output

#### 3.2 XSS (Cross-Site Scripting)
```html
<!-- Test payloads in input velden: -->
<script>alert('XSS')</script>
<img src=x onerror=alert('XSS')>
javascript:alert('XSS')

<!-- Focus op:  -->
- Player names
- Training session beschrijvingen
- Video tags/descriptions
- Comments/notes velden
```

**✅ Verwacht resultaat**: Scripts worden escaped/gefilterd

#### 3.3 File Upload Security
```bash
# Als file upload beschikbaar:
1. Upload .php, .js, .html bestanden
2. Test oversized files (>10MB)
3. Test executable files (.exe, .bat)
4. Check uploaded file URLs voor direct access
```

**✅ Verwacht resultaat**: Alleen toegestane bestandstypes, size limits

---

## 🚀 Productie Testing (2-3 uur)

### Stap 1: OWASP ZAP Automated Scan (60 min)

#### 1.1 ZAP Setup
```bash
1. Start OWASP ZAP
2. Manual Explore → voer productie URL in
3. Configureer authentication (session cookies)
4. Stel scope in: alleen jouw domein
```

#### 1.2 Spider & Scan
```bash
1. Spider de applicatie (30 min crawl time)
2. Active Scan starten (medium intensity)
3. Laat draaien terwijl je handmatige tests doet
4. Review results na 30-45 minuten
```

**✅ Focus op**: High/Medium severity findings

### Stap 2: Browser Security Headers (15 min)

```bash
# Check in browser DevTools Network tab:
curl -I https://jouw-app.netlify.app

# Vereiste headers:
- Content-Security-Policy
- X-Frame-Options: DENY/SAMEORIGIN
- X-Content-Type-Options: nosniff
- Referrer-Policy: strict-origin-when-cross-origin
- Permissions-Policy
```

**✅ Verwacht resultaat**: Alle security headers aanwezig

### Stap 3: API Endpoint Discovery (30 min)

#### 3.1 Hidden Endpoints
```bash
# In browser DevTools:
1. Ga door alle app functies
2. Noteer alle API calls in Network tab
3. Test onbeschermde endpoints:
   - /api/admin/*
   - /api/debug/*
   - /api/internal/*
```

#### 3.2 Rate Limiting Test
```bash
# Test API rate limits:
1. Kies 1 API endpoint (bijv. login)
2. Maak 50+ requests in korte tijd
3. Check voor rate limiting/CAPTCHA
```

**✅ Verwacht resultaat**: Rate limiting na X requests

### Stap 4: Business Logic Testing (45 min)

#### 4.1 Subscription Limits
```bash
# Test tier restrictions:
1. Maak gratis account
2. Probeer premium features te activeren
3. Test max players/teams limits
4. Manipuleer subscription status via browser tools
```

#### 4.2 Payment Logic (als applicable)
```bash
# Als er betalingen zijn:
1. Start upgrade proces
2. Manipuleer bedragen in browser
3. Onderbreek payment flow
4. Test duplicate payments
```

**✅ Verwacht resultaat**: Limits worden afgedwongen server-side

---

## 🔄 CI/CD Pipeline Audit (1 uur)

### Stap 1: GitHub Repository Security (20 min)

#### 1.1 Repository Settings Check
```bash
# Check via GitHub web interface:
□ Private repository (niet public)
□ Branch protection rules op main
□ Required PR reviews enabled
□ Required status checks
□ Secrets scanning enabled
□ Dependency alerts enabled
```

#### 1.2 Secrets Management
```bash
# Check GitHub Repository → Settings → Secrets:
□ Geen hardcoded API keys in code
□ SUPABASE_URL als repository secret
□ SUPABASE_ANON_KEY als repository secret
□ Geen credentials in commit history
```

### Stap 2: GitHub Actions Security (25 min)

#### 2.1 Workflow Permissions
```yaml
# Check in .github/workflows/*.yml files:
permissions:
  contents: read  # Minimale permissions
  actions: read
  security-events: write  # Voor security scans
```

#### 2.2 Third-party Actions Security
```bash
# Review alle third-party actions:
□ Gebruik pinned versions (niet @main)
□ Alleen verified/popular actions
□ Check voor suspicious permissions
□ No unofficial marketplace actions
```

#### 2.3 Security Scanning Integration
```yaml
# Voeg toe aan workflow als niet aanwezig:
- name: Run security scan
  uses: securecodewarrior/github-action-add-sarif@v1
  with:
    sarif-file: security-scan-results.sarif
```

### Stap 3: Deployment Security (15 min)

#### 3.1 Environment Variables
```bash
# Check deployment config:
□ Productie secrets apart van development
□ Geen debug flags in productie
□ Proper environment variable naming
□ No sensitive data in build logs
```

#### 3.2 Build Security
```bash
# Check build process:
□ Dependency vulnerability scanning
□ SAST (Static Analysis) in pipeline
□ Container scanning (als applicable)
□ License compliance checks
```

---

## ✅ Minimale Vereisten Checklist

### 🔒 Authentication & Authorization
- [ ] **Magic links expiren na 10 minuten**
- [ ] **Sessions expiren na inactiviteit (30 min)**
- [ ] **MFA kan niet worden bypassed**
- [ ] **Session cookies hebben security flags**

### 🏢 Multi-Tenant Security
- [ ] **Organization data volledig geïsoleerd**
- [ ] **IDOR attacks falen (403/empty results)**
- [ ] **RLS policies werken correct**
- [ ] **URL parameter manipulation faalt**

### 🛡️ Input Validation
- [ ] **SQL injection payloads worden geblokkeerd**
- [ ] **XSS scripts worden escaped**
- [ ] **File uploads zijn gelimiteerd & gevalideerd**
- [ ] **Rate limiting op API endpoints**

### 🌐 Production Security
- [ ] **Alle security headers aanwezig**
- [ ] **HTTPS overal afgedwongen**
- [ ] **Geen debug info in productie**
- [ ] **Error messages tonen geen sensitive data**

### 🔄 CI/CD Security
- [ ] **Repository is private**
- [ ] **Branch protection actief**
- [ ] **Secrets management correct**
- [ ] **Dependencies worden gescand**

---

## 🚨 Kritieke Findings - Direct Actie Vereist

| Finding | Impact | Action Required |
|---------|--------|-----------------|
| Cross-tenant data leak | **CRITICAL** | Fix RLS policies immediately |
| SQL injection possible | **HIGH** | Input validation & parameterized queries |
| Session never expires | **HIGH** | Implement session timeout |
| Missing security headers | **MEDIUM** | Add via web server config |
| No rate limiting | **MEDIUM** | Implement API throttling |

---

## 📋 Rapport Template

```markdown
# Database Audit Resultaten - [Datum]

## Overzicht
- **Totaal geteste items**: X
- **Kritieke findings**: X
- **Hoge findings**: X
- **Medium findings**: X

## Kritieke Bevindingen
1. [Beschrijving]
   - **Impact**: [Business impact]
   - **Bewijs**: [Screenshots/logs]
   - **Oplossing**: [Concrete stappen]

## Aanbevelingen
1. **Direct** (binnen 24h): [Kritieke fixes]
2. **Korte termijn** (1 week): [Hoge prioriteit fixes]
3. **Lange termijn** (1 maand): [Verbeteringen]

## Compliance Status
- [ ] OWASP Top 10 compliant
- [ ] GDPR data protection
- [ ] SOC2 security controls
```

---

## 🔧 Tools & Resources

### Gratis Security Tools
- **OWASP ZAP**: https://www.zaproxy.org/
- **Burp Suite Community**: https://portswigger.net/burp/communitydownload
- **Nuclei**: https://github.com/projectdiscovery/nuclei
- **SQLMap**: https://sqlmap.org/

### Browser Extensions
- **Wappalyzer**: Tech stack detection
- **Cookie Editor**: Session manipulation
- **JSON Viewer**: API response analysis

### Supabase Specific
- **Supabase Dashboard**: RLS policy testing
- **SQL Editor**: Direct database queries
- **Auth Settings**: Session configuration

---

**⚠️ Disclaimer**: Test alleen op je eigen applicatie. Gebruik deze checklist niet op systemen waar je geen toestemming voor hebt.

**📞 Noodhulp**: Bij kritieke bevindingen, stop gebruik van productie applicatie tot fixes zijn geïmplementeerd.
