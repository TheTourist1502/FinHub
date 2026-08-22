# Routing Rules

## Adding a new route

1. Add a path constant to `AppRoutes` in `lib/core/routing/app_routes.dart`.
2. Add a `GoRoute` (or `StatefulShellBranch`) in `lib/core/routing/app_router.dart`.
3. If the route needs non-default access, add an entry to `AppRoutes.policies`.
4. Update `.claude/docs/folder-structure.md`.

Default (no policy entry) = protected, any authenticated user. No boilerplate needed for standard protected routes.

## Access policies

Declare policies in `AppRoutes.policies`:

```dart
'/admin':   RoutePolicy(roles: {UserRole.leadership}),
'/reports': RoutePolicy(roles: {UserRole.advisor, UserRole.leadership}),
'/login':   RoutePolicy(isPublic: true),
```

- `isPublic: true` — no auth required (use for login, access-denied).
- `roles` — only listed roles may enter; others → `/access-denied`.
- Child routes inherit the nearest ancestor policy automatically; no duplication needed.

Access is decided by role alone. There is no per-permission dimension — if you need finer-grained access, add a role or raise it with the backend, don't reintroduce a permission set the server never populates.

## Guard logic

All logic lives in `routeGuard` (`lib/core/routing/route_guard.dart`). Never place auth or role checks inside screens, widgets, or notifiers.

## Auth state

- `AuthAuthenticated` carries the authenticated `User` (including its role).
- `currentUserProvider` is a sync `Provider<User?>` — never treat it as async.
- The router re-evaluates on every `authNotifierProvider` state change via `_RouterChangeNotifier`.

## Redirect preservation

Unauthenticated users redirected to `/login` get a `?redirect=<path>` query parameter. After login they are automatically sent to that destination. No manual handling required in screens.
