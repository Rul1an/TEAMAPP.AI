### RBAC Matrix – JO17 Tactical Manager (UI/Route/Action)

Referentie voor rollen en toegestane acties/routes. Backend-RLS moet dit minimaal even streng afdwingen.

Rollen: Bestuurder, Hoofdcoach, Assistent, Speler, Ouder, Admin

#### Routes toegang per rol

| Route | Bestuurder | Hoofdcoach | Assistent | Speler | Ouder | Admin |
|---|---|---|---|---|---|---|
| /dashboard | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| /players | ✓ | ✓ | ✓ (beperkt) | ✓ (view) | ✓ (view) | ✓ |
| /training | ✓ | ✓ | ✓ | ✓ (view) | ✓ (view) | ✓ |
| /training-sessions | ✓ | ✓ | ✓ | ✗ | ✗ | ✓ |
| /exercise-library | ✓ | ✓ | ✓ | ✗ | ✗ | ✓ |
| /field-diagram-editor | ✓ | ✓ | ✓ | ✗ | ✗ | ✓ |
| /exercise-designer | ✓ | ✓ | ✓ | ✗ | ✗ | ✓ |
| /matches | ✓ | ✓ | ✓ | ✓ (view) | ✓ (view) | ✓ |
| /lineup | ✓ | ✓ | ✓ | ✗ | ✗ | ✓ |
| /annual-planning | ✓ | ✓ | ✗ | ✗ | ✗ | ✓ |
| /season | ✓ | ✓ | ✗ | ✗ | ✗ | ✓ |
| /insights | ✓ | ✓ | ✗ | ✗ | ✗ | ✓ |
| /admin | ✓ | ✗ | ✗ | ✗ | ✗ | ✓ |
| /svs (tier > basic) | ✓ | ✓ | ✗ | ✗ | ✗ | ✓ |

Legenda: ✓ toegestaan, ✗ verboden; "(view)" betekent alleen lezen.

#### Acties per rol (PermissionService.canPerformAction)

| Actie | Bestuurder | Hoofdcoach | Assistent | Speler | Ouder | Admin |
|---|---|---|---|---|---|---|
| view_player | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| create_player | ✓ | ✓ | ✗ | ✗ | ✗ | ✓ |
| edit_player | ✓ | ✓ | ✗ | ✗ | ✗ | ✓ |
| delete_player | ✓ | ✓ | ✗ | ✗ | ✗ | ✓ |
| view_training | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| create_training | ✓ | ✓ | ✗ | ✗ | ✗ | ✓ |
| edit_training | ✓ | ✓ | ✗ | ✗ | ✗ | ✓ |
| delete_training | ✓ | ✓ | ✗ | ✗ | ✗ | ✓ |
| manage_training_sessions | ✓ | ✓ | ✓ | ✗ | ✗ | ✓ |
| create_match | ✓ | ✓ | ✗ | ✗ | ✗ | ✓ |
| edit_match | ✓ | ✓ | ✗ | ✗ | ✗ | ✓ |
| delete_match | ✓ | ✓ | ✗ | ✗ | ✗ | ✓ |
| view_match | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| manage_exercise_library | ✓ | ✓ | ✓ | ✗ | ✗ | ✓ |
| access_field_diagram_editor | ✓ | ✓ | ✓ | ✗ | ✗ | ✓ |
| access_exercise_designer | ✓ | ✓ | ✓ | ✗ | ✗ | ✓ |
| manage_organization | ✓ | ✗ | ✗ | ✗ | ✗ | ✓ |
| view_analytics | ✓ | ✓ | ✗ | ✗ | ✗ | ✓ |
| access_annual_planning | ✓ | ✓ | ✗ | ✗ | ✗ | ✓ |

Opmerking: SVS-toegang is afhankelijk van `OrganizationTier` > basic.

#### Verificatie
- Unit tests voor `PermissionService` checken bovenstaande matrix.
- RLS-policies in Supabase moeten hetzelfde afdwingen voor INSERT/UPDATE/DELETE/SELECT.


