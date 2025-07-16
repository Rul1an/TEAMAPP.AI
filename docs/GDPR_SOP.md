# GDPR Standard Operating Procedure (SOP)

> Draft – Sprint 7 deliverable (VEO-118)

## Scope
This SOP describes data-protection controls for **TeamApp.ai** edge-storage and analytics systems in compliance with *GDPR* and *CCPA* regulations.

## Data Inventory
| Dataset | Purpose | Location | Retention |
|---------|---------|----------|-----------|
| User profiles | Authentication | Supabase (EU) | Until account deletion |
| Usage metrics | Billing & analytics | TimescaleDB (EU/US) | 13 months |
| Logs (edge) | Debug & audit | Object Storage (minio) | 30 days |

## Roles & Responsibilities
* **DPO** – Oversees compliance & incident response.
* **Engineering** – Implements technical safeguards.
* **Support** – Handles user data-requests.

## Technical Safeguards
1. **Geo-fenced storage** (EU-only for personal data).
2. **KMS encryption-at-rest** (CMEK, rotation ≥ 365 d).
3. **mTLS** edge ↔ storage + JWT audience checks.
4. **Access logging** and immutable audit-trail (Object Lock).

## Operational Procedures
* Data-subject export → *support portal* (max 30 days).
* Deletion requests → trigger `data-deletion` workflow; confirm via signed audit-log.
* Quarterly **DPIA** review and updates.

## Incident Response
| Severity | Example | Response Time | Escalation |
|----------|---------|---------------|------------|
| High | Breach of personal data | 24 h | DPO + CISO |
| Medium | Suspicious access | 72 h | Eng Lead |
| Low | False alert | 5 d | Support |

---
_Last updated: {{DATE}}_