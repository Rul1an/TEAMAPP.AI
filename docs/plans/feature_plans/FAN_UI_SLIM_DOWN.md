# Fan UI Slim-Down – Implementation Log (Q3 2025)

_Last updated: 2025-07-24_

This doc tracks incremental work on TODO **fan_ui_slim_down**.

## Delivered Today
| Change | File | Notes |
|--------|------|-------|
| Dashboard grid (5 cards) | `fan_home_screen.dart` | Lightweight, ≤120 LOC widget |
| Core routes cloned | `router_fan.dart` | Training / Matches / Players / Calendar routes added |

## Next
1. Hide staff-only FABs already implemented via `PermissionService.isViewOnlyUser`.
2. Add golden test for FanHome grid (ensure cards visible on 375×812).
3. Add widget test: tap card ➜ navigates to route.

## Acceptance Criteria
* Fan flavour starts at `/dashboard`; navigation to 4 core sections works.
* No analyzer warnings; file < 200 LOC.
* Golden test passes; CI green.

Owner: FE-guild
