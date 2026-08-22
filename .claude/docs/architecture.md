# Flutter Architecture & Performance Guide

## Architecture

### Layered Feature Architecture

| Layer | Location | Responsibility |
|---|---|---|
| `data/` | `lib/features/<feature>/data/` | API calls, local storage, JSON mapping |
| `domain/` | `lib/features/<feature>/domain/` | Immutable models, repository interfaces, business logic |
| `presentation/` | `lib/features/<feature>/presentation/` | Riverpod providers, screens, widgets |

### Import Rules

- `data/` must not import `presentation/`.
- `domain/` must not import `data/` or `presentation/`.
- `presentation/` depends only on `domain/`.
- Shared infrastructure belongs in `lib/core/`.

### Dependency Injection

Use abstract repositories and inject implementations with Riverpod.

## State Management

Use Riverpod exclusively.

| Provider | Usage |
|---|---|
| Provider | Derived values |
| FutureProvider | One-shot async |
| AsyncNotifierProvider | Async state |
| NotifierProvider | Mutable local state |

Use `ref.watch()` for reactive UI and `ref.read()` in callbacks.

## Presentation

- Screen
- Section Widgets
- Feature Widgets
- Atomic Widgets

## Testing

- Unit tests for repositories, notifiers and mappers.
- Widget tests for UI.
- Use in-memory implementations instead of real APIs.

---

# Performance Guide

- Use `CustomScrollView` + `SliverList`
- Prefer `ListView.builder`
- Cursor pagination
- `RepaintBoundary`
- `const` widgets
- Stable `ValueKey`
- `CachedNetworkImage`
- `itemExtent`
- `compute()` for JSON parsing
- Skeleton loading
- Flutter DevTools profiling

## Production Checklist

- [x] Slivers
- [x] Lazy Lists
- [x] Cursor Pagination
- [x] Riverpod
- [x] RepaintBoundary
- [x] Stable Keys
- [x] Immutable Models
- [x] Cached Images
- [x] Background Parsing