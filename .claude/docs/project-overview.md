# FinancialApp FA Mobile

Flutter application for iOS/Android focused on financial advisors. Advisors use the app to observe portfolios of households and clients, raise service requests, manage tasks, and explore market insights articles and news.

## User Roles

Role-based access is enforced via `AuthService.getUserRole()` and used for UI gating throughout the app.

| Role | Description |
|------|-------------|
| `admin` | Full administrative access — FinancialApp internal staff |
| `advisor` | Financial advisor — can view and manage assigned client portfolios |
| `client` | End investor — read-only access to their own portfolio |

**Current scope:** build features for the `advisor` role only. The architecture supports easy extension to `client` and `superuser` in the future.
