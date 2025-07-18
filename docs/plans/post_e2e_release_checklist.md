# Post-E2E Release Checklist – Sprint 1

> This document defines what happens **after the staging E2E regression suite passes**.
>
> Goal: merge PR #74, tag the release, and deploy safely to production.

---

## 1  QA Sign-off

1. Open staging app ➜ run through the **Manual QA checklist** in `docs/plans/manual_QA_release_checklist.md`.
2. Log any bugs to project board **Sprint-1 – QA**; all P0/P1 must be fixed before go-live.
3. When everything passes, add comment to PR #74:
   ```
   ✅ Staging E2E + manual QA passed – ready to merge
   ```

## 2  Merge protocol

1. Ensure PR #74 has a green “Flutter Web CI/CD” check.
2. Press **Squash & merge** into `main`.
3. Delete the feature branch after merge (optional, GitHub prompt).

## 3  Release notes & tag

Already prepared in `CHANGELOG.md` as version **0.9.0**.

1. Create a GitHub Release from tag `v0.9.0` (auto-created earlier).
2. Paste the changelog section and attach coverage badge.
3. Publish.

## 4  Production deploy

Merge on `main` triggers **advanced-deployment.yml**:

1. Build → deploy Flutter Web to Cloud Run bucket.
2. Run Supabase DB migrations (RLS & new tables).
3. Lighthouse CI runs; threshold ≥ 85.
4. Health-check `/health` must return `200`.

Rollback: restore previous Cloud Run revision (kept for 14 days).

## 5  Post-deploy tasks

* Verify Sentry shows no new fatal errors after 1 h.
* Update **docs/release_history.md** with 0.9.0 entry.
* Close Sprint 1 board, move leftover issues to Sprint 2 backlog.

---

*Generated automatically on 2025-07-15.*