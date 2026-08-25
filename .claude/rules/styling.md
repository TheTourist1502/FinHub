# Styling & Theming Rules

## Colors

- Widgets must read colors from `Theme.of(context).colorScheme` for any color with a semantic M3 role (`onSurface`, `surface`, `primary`, `outlineVariant`, `error`).
- Never hardcode hex values in widgets.
- `AppColors` must only be imported in `app_theme.dart`, `app_typography.dart`, and widgets that need a color with no M3 equivalent (`logoBlue`, `cardBorder`, `cardBlurOverlay`, `footerText`, `subtitleText`).

## Color lookup order when implementing a feature

When you need a color, check in this order and stop at the first match:

1. **`context.appColors.<token>`** — use if a semantic token exists in `AppColorTokens` (accessed via `lib/core/theme/app_color_tokens.dart`). This is the default for any adaptive color.
2. **`AppColors.<primitive>`** — use if no semantic token covers the case but the raw primitive exists in `AppColors` (accessed via `lib/core/theme/app_colors.dart`). Only valid inside `app_theme.dart`, `app_typography.dart`, or a widget that genuinely has no M3 / token equivalent.
3. **Add a new static constant to `AppColors`** — only if the color does not exist anywhere in `AppColors` or `AppColorTokens`. Add it under the appropriate primitive group (brand, blue, neutral, teal, gold, lime, coral, amber, purple, or static) with a `///` doc comment. Never inline a raw `Color(0xFF…)` literal directly in a widget.

## Buttons

- Use `AppTheme.dangerStyle(context)` on any `ElevatedButton` that triggers a destructive action.

## Search Boxes

- Every search box is `AppSearchField` (`lib/shared/widgets/inputs/app_search_field.dart`). Never hand-build a search `TextField`, its `InputDecoration`, or its clear button.
- The style lives only in `AppTheme.searchDecoration(context, …)`. A search box that needs a different look is a design change, not a call-site override.
- Never pin the field's height — it sizes itself so every screen matches.
- Use `AppSearchFieldShimmer` for the loading placeholder; never write a per-feature search skeleton.

## Disabled Inputs

- A disabled input fills with `inputDisabledBg` — its own token, not `surfaceDisabled`, which stays for disabled non-input surfaces. This is resolved by the theme's `WidgetStateColor` fill — never branch on `enabled` at a call site to pick a fill colour.

## Icons

- Always use `iconify_flutter` with the `mdi` (Material Design Icons) set and static inline SVG strings.
- The app's own mark is `Mdi.finance`, drawn by `AppLogo` / `AppWordmarkLogo`
  (`lib/shared/widgets/brand/app_logos.dart`). There is no logo image asset — a
  screen that needs the brand uses those widgets, never a raw `Iconify`.
- Never use icon sets that fetch from a remote URL at runtime.

## Snackbars / Toasts

- Always use `snackbarServiceProvider` (from `lib/core/feedback/snackbar_service.dart`) for user-facing messages.
- Never call `ScaffoldMessenger` directly from feature widgets or notifiers.
