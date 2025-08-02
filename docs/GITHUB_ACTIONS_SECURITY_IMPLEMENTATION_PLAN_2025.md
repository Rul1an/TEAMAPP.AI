# GitHub Actions Security Implementation Plan 2025

**Document:** GitHub Actions Security Remediation Implementation Plan
**Datum:** 3 augustus 2025
**Status:** Ready for Implementation
**Prioriteit:** KRITIEK - Immediate Action Required

## 🎯 Executive Summary

Naar aanleiding van de CI/CD Pipeline Security Audit zijn kritieke beveiligingsrisico's geïdentificeerd in onze GitHub Actions configuratie. Dit implementatieplan bevat concrete stappen om deze risico's te mitigeren volgens 2025 industry best practices.

## 📊 Audit Findings Summary

### 🔴 Kritieke Bevindingen
1. **Excessive Workflow Permissions** - GITHUB_TOKEN heeft write access
2. **Third-party Actions Security Gaps** - Geen commit SHA pinning
3. **Secrets Management Modernization** - Geen OIDC implementatie

### 📈 Risk Assessment
- **Current Security Level:** Medium-High Risk
- **Target Security Level:** Enterprise-Grade Security
- **Implementation Timeline:** 4 weken

---

## 🚀 Implementation Roadmap

### **FASE 1: IMMEDIATE ACTIONS (Week 1)**

#### 1.1 Workflow Permissions Hardening
**Prioriteit:** 🔴 KRITIEK
**Tijdsinvestering:** 4-6 uur
**Owner:** DevOps Team

**Acties:**
```yaml
# Huidige configuratie (ONVEILIG):
permissions:
  contents: write
  pull-requests: write
  deployments: write
  statuses: write
  checks: write

# Nieuwe configuratie (VEILIG):
permissions: {}  # Force job-level specification
```

**Implementatie Steps:**
1. **Backup huidige workflows**
   ```bash
   cp -r .github/workflows .github/workflows-backup-$(date +%Y%m%d)
   ```

2. **Update main-ci.yml**
   - Verwijder global permissions block
   - Voeg job-level permissions toe per job

3. **Update alle workflow files**
   - Audit elk workflow bestand
   - Implementeer least-privilege per job

**Verificatie:**
```bash
# Check workflow permissions in logs
grep -r "permissions:" .github/workflows/
```

#### 1.2 Third-party Actions Inventory
**Prioriteit:** 🔴 KRITIEK
**Tijdsinvestering:** 3-4 uur
**Owner:** DevOps Team

**Acties:**
1. **Scan alle workflows voor third-party actions**
   ```bash
   find .github/workflows -name "*.yml" -exec grep -H "uses:" {} \; | grep -v "actions/"
   ```

2. **Create actions allowlist**
   - Document alle gebruikte third-party actions
   - Verify creator reputation
   - Check for security advisories

3. **Priority actions voor immediate pinning:**
   - step-security/harden-runner
   - Alle non-GitHub actions

---

### **FASE 2: SECURITY HARDENING (Week 2)**

#### 2.1 Commit SHA Pinning Implementation
**Prioriteit:** 🟠 HOOG
**Tijdsinvestering:** 6-8 uur
**Owner:** DevOps Team

**Implementation Strategy:**
```yaml
# Voor: Tag-based (ONVEILIG)
uses: actions/checkout@v4

# Na: SHA-based (VEILIG)
uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11  # v4.1.1
```

**Workflow per Action:**
1. **Identify current version tag**
2. **Lookup corresponding commit SHA**
3. **Update workflow files**
4. **Add comment with version for maintenance**

**Automation Script:**
```bash
#!/bin/bash
# pin-actions.sh - Automate SHA pinning

# Example implementation
echo "Pinning actions to commit SHAs..."
find .github/workflows -name "*.yml" -exec sed -i.bak 's/actions\/checkout@v4/actions\/checkout@b4ffde65f46336ab88eb53be808477a3936bae11  # v4.1.1/g' {} \;
```

#### 2.2 Organization-level Security Settings
**Prioriteit:** 🟠 HOOG
**Tijdsinvestering:** 2-3 uur
**Owner:** GitHub Admin

**GitHub Organization Settings:**
1. **Actions Permissions**
   - Limit to specific allowed actions
   - Require approval for new actions

2. **Default Workflow Permissions**
   - Set to "Read" only
   - Require explicit write permissions

3. **Third-party Actions Policy**
   ```
   ✅ Allow actions created by GitHub
   ✅ Allow Marketplace verified creators
   ✅ Allow specified actions (allowlist)
   ❌ Allow all actions
   ```

---

### **FASE 3: ADVANCED SECURITY (Week 3)**

#### 3.1 OpenID Connect (OIDC) Implementation
**Prioriteit:** 🟡 MEDIUM-HIGH
**Tijdsinvestering:** 8-12 uur
**Owner:** DevOps + Cloud Team

**Cloud Provider Setup:**

**AWS Configuration:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::ACCOUNT-ID:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
          "token.actions.githubusercontent.com:sub": "repo:ORG/REPO:ref:refs/heads/main"
        }
      }
    }
  ]
}
```

**Workflow Implementation:**
```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::123456789012:role/GitHubActions
          aws-region: us-east-1
```

#### 3.2 Secrets Management Modernization
**Prioriteit:** 🟡 MEDIUM
**Tijdsinvestering:** 6-8 uur
**Owner:** DevOps Team

**Actions:**
1. **Audit current secrets usage**
   ```bash
   grep -r "secrets\." .github/workflows/
   ```

2. **Implement Environment Secrets**
   - Create production environment
   - Set required reviewers
   - Migrate sensitive secrets

3. **Remove long-lived credentials**
   - Replace with OIDC where possible
   - Rotate remaining secrets

---

### **FASE 4: MONITORING & COMPLIANCE (Week 4)**

#### 4.1 Security Monitoring Implementation
**Prioriteit:** 🟡 MEDIUM
**Tijdsinvestering:** 4-6 uur
**Owner:** DevOps Team

**Monitoring Setup:**
1. **Dependabot Configuration**
   ```yaml
   # .github/dependabot.yml
   version: 2
   updates:
     - package-ecosystem: "github-actions"
       directory: "/"
       schedule:
         interval: "weekly"
   ```

2. **Security Scanning Workflow**
   ```yaml
   name: Security Scan
   on:
     pull_request:
       paths: ['.github/workflows/**']

   jobs:
     security-scan:
       runs-on: ubuntu-latest
       permissions:
         contents: read
       steps:
         - uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11
         - name: Run workflow security scan
           run: |
             # Use zizmor or similar tool
             npx zizmor scan .github/workflows/
   ```

#### 4.2 Documentation & Training
**Prioriteit:** 🟢 LOW-MEDIUM
**Tijdsinvestering:** 3-4 uur
**Owner:** DevOps Team

**Deliverables:**
1. **Security Guidelines Document**
2. **Developer Training Session**
3. **Security Checklist for New Workflows**

---

## ⚡ Quick Wins (Eerste 24 uur)

### Immediate Actions
1. **Set Repository Default Permissions to Read-Only**
   - GitHub Settings → Actions → General
   - Workflow permissions: Read repository contents and packages permissions

2. **Enable Dependabot for Actions**
   ```yaml
   # .github/dependabot.yml (create if not exists)
   version: 2
   updates:
     - package-ecosystem: "github-actions"
       directory: "/"
       schedule:
         interval: "weekly"
   ```

3. **Add Security Check to Main Workflow**
   ```yaml
   - name: Harden Runner
     uses: step-security/harden-runner@63c24ba6bd7ba022e95695ff85de572c04a18142  # v2.7.0
     with:
       egress-policy: audit
   ```

---

## 🧪 Testing Strategy

### Pre-Implementation Testing
1. **Create feature branch:** `security/github-actions-hardening`
2. **Test in isolated environment**
3. **Verify all workflows still function**
4. **Performance impact assessment**

### Rollback Plan
1. **Backup current configuration**
2. **Document all changes**
3. **Create rollback scripts**
4. **Define rollback triggers**

---

## 📋 Implementation Checklist

### Week 1: Immediate Actions
- [ ] Backup alle workflow bestanden
- [ ] Update workflow permissions naar read-only default
- [ ] Inventory alle third-party actions
- [ ] Set organization-level security settings
- [ ] Test critical workflows

### Week 2: Security Hardening
- [ ] Pin alle third-party actions naar commit SHA
- [ ] Update action references met version comments
- [ ] Implement allowlist voor approved actions
- [ ] Configure branch protection rules
- [ ] Update CI/CD documentation

### Week 3: Advanced Security
- [ ] Setup OIDC voor cloud providers
- [ ] Migrate secrets naar environment-based
- [ ] Implement mandatory reviews voor production
- [ ] Configure secret scanning
- [ ] Test OIDC authentication flows

### Week 4: Monitoring & Compliance
- [ ] Enable Dependabot voor actions updates
- [ ] Setup security monitoring workflows
- [ ] Create security guidelines documentation
- [ ] Conduct team training session
- [ ] Perform final security audit

---

## 📊 Success Metrics

### Security KPIs
- **Workflow Permission Reduction:** 80% reduction in write permissions
- **Third-party Action Security:** 100% SHA pinning coverage
- **Secret Exposure Risk:** 90% reduction via OIDC migration
- **Vulnerability Detection Time:** <24 hours via Dependabot

### Operational KPIs
- **Deployment Success Rate:** Maintain >99%
- **Build Time Impact:** <10% increase
- **Developer Productivity:** No degradation
- **Compliance Score:** 95%+ security standards

---

## 🔍 Post-Implementation Review

### 30-Day Review Checklist
- [ ] Security audit van alle workflows
- [ ] Performance impact assessment
- [ ] Developer feedback collection
- [ ] Compliance verification
- [ ] Documentation updates

### Ongoing Maintenance
- **Weekly:** Review Dependabot alerts
- **Monthly:** Actions usage audit
- **Quarterly:** Security policy review
- **Annually:** Full security assessment

---

## 🚨 Risk Mitigation

### Implementation Risks
1. **Workflow Breakage:** Mitigated door extensive testing
2. **Performance Impact:** Monitored en geoptimaliseerd
3. **Developer Resistance:** Addressed via training
4. **Security Gaps:** Covered door phased approach

### Contingency Plans
- **Immediate rollback capability**
- **24/7 monitoring during rollout**
- **Incident response procedures**
- **Backup authentication methods**

---

## 📞 Support & Escalation

### Implementation Team
- **Project Lead:** DevOps Manager
- **Technical Lead:** Senior DevOps Engineer
- **Security Advisor:** CISO/Security Team
- **Quality Assurance:** QA Lead

### Escalation Path
1. **Technical Issues:** DevOps Team → Technical Lead
2. **Security Concerns:** Security Advisor → CISO
3. **Business Impact:** Project Lead → Management
4. **Critical Incidents:** All hands escalation

---

## ✅ Approval & Sign-off

### Required Approvals
- [ ] **Technical Review:** DevOps Team Lead
- [ ] **Security Review:** Security Team/CISO
- [ ] **Business Review:** Product Owner
- [ ] **Final Approval:** Engineering Manager

### Implementation Authorization
**Approved by:** _________________
**Date:** _________________
**Implementation Start Date:** _________________

---

**Document Version:** 1.0
**Last Updated:** 3 augustus 2025
**Next Review:** 3 september 2025

**Classification:** Internal Use
**Retention:** 3 years
