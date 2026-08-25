# Styling & Theming

## Theme Setup

`AppTheme` in `lib/core/theme/app_theme.dart` exposes two themes: `AppTheme.client` (light, default) and `AppTheme.dark`. The active theme is selected via `ThemeConfig.activeTheme` and applied as `MaterialApp(theme: AppTheme.active)`.

Both themes use Material 3 (`useMaterial3: true`) with `ColorScheme.fromSeed(seedColor: AppColors.primaryAction)`. Several M3-generated tones are overridden explicitly (see Color Tokens below).

---

## Color Tokens — `lib/core/theme/app_colors.dart`

**Rule:** Never hardcode hex values in widgets. Use `AppColors.*` constants in theme construction. In widgets, read colors from `Theme.of(context).colorScheme` where a semantic role exists.

### Light palette

| Constant | Hex | Usage |
|---|---|---|
| `backgroundPage` | `#F8FAFC` | `colorScheme.surface` → scaffold background |
| `cardBackground` | `#FFFFFF` | App bar, card surfaces, input fill |
| `cardBorder` | `#F3F4F6` | Login card border |
| `cardBlurOverlay` | `#0D00A3FF` | Login card decorative blur |
| `logoBlue` | `#1FB4E6` | "finhub" wordmark only |
| `primaryAction` | `#00A3FF` | `colorScheme.primary` → buttons, focus rings, ripples |
| `headingText` | `#1A202C` | `colorScheme.onSurface` |
| `subtitleText` | `#718096` | Secondary text, hints, divider labels |
| `footerText` | `#64748B` | Disclaimer / footer text |
| `textOnPrimary` | `#FFFFFF` | `colorScheme.onPrimary` and `onError` |
| `inputBorder` | `#E2E8F0` | `colorScheme.outlineVariant` → input borders, card borders, dividers |
| `errorColor` | `#E53E3E` | `colorScheme.error` → form errors and danger buttons |

### Dark palette (theme construction only)

| Constant | Hex | Usage |
|---|---|---|
| `backgroundPageDark` | `#0F172A` | `colorScheme.surface` (dark) |
| `cardBackgroundDark` | `#1E293B` | App bar, input fill (dark) |
| `inputBorderDark` | `#334155` | Input borders, dividers (dark) |

---

## ColorScheme Overrides

The following M3 auto-generated tones are explicitly pinned in `AppTheme.client`:

```
surface             → AppColors.backgroundPage
onSurface           → AppColors.headingText
primary             → AppColors.primaryAction   (M3 tone-40 would be too dark)
onPrimary           → AppColors.textOnPrimary
surfaceContainerLow → AppColors.cardBackground  (M3 generates blue-tinted tone)
outlineVariant      → AppColors.inputBorder     (M3 generates blue-tinted tone)
error               → AppColors.errorColor
onError             → AppColors.textOnPrimary
```

---

## Typography — `lib/core/theme/app_typography.dart`

Font: **Inter** (bundled). All styles are `const`.

| Constant | Weight | Size | Color |
|---|---|---|---|
| `logoStyle` | Bold 700 | 24 | `logoBlue` |
| `headingLarge` | Bold 700 | 24 | inherits `onSurface` |
| `bodyMedium` | Regular 400 | 14 | `subtitleText` |
| `labelMedium` | Medium 500 | 14 | inherits `onSurface` |
| `inputText` | Regular 400 | 16 | inherits `onSurface` |
| `inputHint` | Regular 400 | 16 | `subtitleText` |
| `searchText` | Regular 400 | 14 | applied by `AppTheme.searchDecoration` |
| `buttonLabel` | Medium 500 | 14 | `textOnPrimary` |
| `socialButtonLabel` | Medium 500 | 14 | inherits `onSurface` |
| `dividerLabel` | SemiBold 600 | 12 | `subtitleText` |
| `footerBody` | Regular 400 | 12 | `subtitleText` |
| `footerLink` | Medium 500 | 12 | inherits `onSurface`, underlined |
| `disclaimer` | Regular 400 | 10 | `footerText` |
| `disclaimerLink` | Regular 400 | 10 | `footerText`, underlined |
| `donutCenterLabel` | Medium 500 | 9 | apply via `.copyWith(color: ...)` |
| `donutCenterPercentage` | Bold 700 | 16 | apply via `.copyWith(color: ...)` |
| `donutCenterValue` | Medium 500 | 10 | apply via `.copyWith(color: ...)` |

---

## Dimensions — `lib/core/theme/app_dimensions.dart`

| Constant | Value | Usage |
|---|---|---|
| `cardBorderRadius` | 24 | Login card |
| `inputBorderRadius` | 12 | Inputs |
| `buttonBorderRadius` | 12 | All buttons |
| `cardHorizontalPadding` | 24 | Login card inner padding |
| `cardVerticalPadding` | 32 | Login card inner padding |
| `cardHorizontalMargin` | 16 | Login card ↔ screen edge |
| `buttonHeight` | 48 | Primary and social buttons |
| `socialButtonIconSize` | 20 | Icons inside social buttons |
| `minTouchTarget` | 48 | Accessibility minimum |
| `cardBlurCircleSize` | 160 | Decorative blur diameter |
| `cardBlurSigma` | 32 | Decorative blur sigma |
| `sortHeaderRowHeight` | 28 | `SortHeaderRow` height |
| `sortHeaderLabelFlex` | 55 | `SortHeaderRow` label flex |
| `sortHeaderSortFlex` | 45 | `SortHeaderRow` sort-control flex |

---

## Search Box

Every search box in the app is `AppSearchField` (`lib/shared/widgets/inputs/app_search_field.dart`). Its style lives in one place — `AppTheme.searchDecoration(context, hint:, suffixIcon:)` — so the control looks identical on every screen: magnify prefix, 12 px radius, `borderStrong` resting border, `interactiveDefault` focus ring, `searchText` (14 px) hint and value.

- Never hand-build a search `TextField` or its `InputDecoration`. Never wrap the field in a fixed-height `SizedBox` — it sizes itself.
- The clear ("x") button is built in and appears as soon as the field holds text; it clears the controller and re-fires `onChanged('')`. Pass `onClear` only for extra side effects (unfocus, resetting a separate provider).
- While the first page of data is in flight, render `AppSearchFieldShimmer` in the field's place — never a per-feature search skeleton.

## Disabled Inputs

Every input's fill resolves through a `WidgetStateColor` in `inputDecorationTheme` (and in `AppTheme.searchDecoration`), so a disabled field greys to `inputDisabledBg` on its own. Never branch on `enabled` at a call site to pick a fill colour. Select triggers (`AppSingleSelect` / `AppMultiSelect`) read the same token through `appSelectInputDecoration`. `surfaceDisabled` is unrelated — it stays the disabled *surface* tone for non-input widgets.

---

## Danger / Destructive Button

Use `AppTheme.dangerStyle(context)` on any `ElevatedButton` that triggers a destructive action. It reads `colorScheme.error` / `colorScheme.onError` so it adapts to both themes automatically.

---

## Icons

Use `iconify_flutter` for all icons. Always use the **`mdi` (Material Design Icons) set with static inline SVG strings** — never use icon sets that fetch from a remote URL at runtime.

```dart
// Correct — static MDI SVG string, no network needed
Iconify(Mdi.home, size: 24, color: Colors.black)

// Wrong — do not use other icon sets or network-fetched variants
```

---

## Motion — `lib/core/motion/app_motion.dart`

The metaphor is money coming to rest: everything arrives quickly and decelerates
into position. Nothing springs or overshoots — an advisor reading a balance
should never watch it bounce.

### Tokens

| Token | Value | Used for |
|---|---|---|
| `AppMotion.quick` | 150 ms | Chip selection, icon swaps, press feedback |
| `AppMotion.base` | 280 ms | Skeleton-to-data crossfades, expansion |
| `AppMotion.chart` | 400 ms | fl_chart's implicit tween growing a plot in |
| `AppMotion.settle` | 520 ms | Section and list-row entrances |
| `AppMotion.hero` | 900 ms | A hero number rolling to its resting value |
| `AppMotion.stagger` | 60 ms | Delay between consecutive staggered entrances |
| `AppMotion.enter` | `easeOutCubic` | Entrances — fast start, gentle stop |
| `AppMotion.settleCurve` | `easeOutQuint` | Hero values only; the long tail is what reads as settling |
| `AppMotion.exit` | `easeInCubic` | Anything leaving the screen |

### Reduced motion

Never pass a raw `Duration` constant to an animation widget. Always go through
`AppMotion.duration(context, AppMotion.base)`, which returns `Duration.zero`
when the platform's "reduce motion" accessibility setting is on so the widget
jumps straight to its final frame. `AppMotion.enabled(context)` exposes the same
flag for widgets that need to branch rather than shorten.

### Master switch — `lib/shared/animations/animations.dart`

`isAnimationApplicable` (default `true`) turns every animation in
`lib/shared/animations/` on or off in one place. Set it to `false` and each one
renders its finished frame immediately — content is still built, laid out and
tappable, it just arrives without motion.

Widgets in that folder read it through `animationsEnabled(context)` and
`animationDuration(context, …)`, which also fold in the platform's reduce-motion
setting. It does **not** cover implicit animations owned by feature widgets
(`AnimatedSwitcher` crossfades, the history chart's tween) or route transitions;
those stay on `AppMotion` directly.

### Shared widgets — `lib/shared/animations/`

- **`SettleIn`** — the standard entrance: a fade plus a 12 px rise, staggered by
  `index`. Plays on mount only, so pull-to-refresh updates content in place
  instead of replaying it. Indices above 8 still animate but drop the stagger
  delay — a row the reader scrolled down to alone has no group to wait for.
  Rows arriving under a fling are placed at rest instead, decided by measured
  scroll speed rather than by index (see `OnScrolledIntoView`).
- **`FigureReveal`** — the roll used by every animated number. It hands its
  `builder` an eased 0→1 progress rather than a finished figure, so an amount
  and its percentage roll off one clock instead of drifting apart on two
  controllers. Lerp each value with `lerpDouble` inside the builder.
- **`SlideIn`** — a livelier entrance than `SettleIn`: the child enters at 150%
  of its own width to one side, swings 8% past its resting place, then damps
  back through 4%, 4% and 2%. A direct port of the `slideLeft` / `slideRight`
  keyframes from `lib/shared/animations/animation.txt`, using
  `FractionalTranslation` so the offsets stay relative to the child's own width
  exactly as CSS percentage translate does. `SlideDirection` is named after the
  source sequences, not the travel: `.left` moves leftward and therefore
  **enters from the right**, which is what the allocation legend uses. Reserved
  for a list arriving beside something else. Wrap the region it travels through
  in a **`SlideInClip`** of the same direction: it clips the entry edge and
  widens the overshoot edge, which a plain `ClipRect` would cut.
- **`Wipe`** — uncovers a subtree left to right by clipping, never by resizing,
  so nothing relayouts as it plays. For a bar whose widths *are* the values —
  the asset-allocation bar — where scaling the whole thing up from nothing
  would show a wrong proportion on every frame but the last. The flat
  counterpart to the allocation donut's clock sweep. Stateless: it takes a
  progress, so a display that also rolls figures drives label and bar from one
  `FigureReveal` rather than a second, drifting ticker.
- **`OnScrolledIntoView`** — fires a callback once, when its box first rises
  above 90% of the screen height. `SettleIn`, `SlideIn` and `FigureReveal` each
  take a `revealOnScroll` flag that routes through it.
- **`Pressable`** — the press dip for tappable cards. Driven by `Listener`, so
  it stays out of the gesture arena and the wrapped card keeps its own tap
  handler and ripple. Only wrap something that actually responds to a tap — a
  dip on an inert row promises an interaction that does not exist.

### When a figure replays its roll

`FigureReveal` runs on mount, and again only when its `replayKey` changes. A
change to the figure alone never replays it. This distinction is the whole
point of the widget: a reader dragging along a chart rewrites the displayed
number many times a second, and restarting the roll on each of those leaves the
figure permanently trailing their finger.

| Display | `replayKey` | Replays on |
|---|---|---|
| `CurrencyHeroValue` | none | First appearance only — the value is touch-reactive |
| `HistoryChartChangeRow` | `(filter, drilled-into month)` | First appearance and any change of plotted range |
| `HouseholdsInsightsCard` figures | none | First appearance only |
| `RecentTransactionCard` amount | none | First appearance only |
| `AccountCard` value and change | none | First appearance only |
| `HouseholdCard` AUM, change and percentage | none | First appearance only |
| Donut centre percentage and value | — | Driven by the sweep's own progress, not a `FigureReveal` |

Hero figures roll in from a fraction of their real value rather than from zero
(`CurrencyHeroValue` from 96%; transaction amounts and both list cards' figures
from 90%). Two reasons: a
balance spinning up from `$0.00` reads as a slot machine, and a figure inside a
`FittedBox` that changes digit count rescales its own type on nearly every
frame. The same reasoning covers an end-aligned column, where a changing digit
count shuffles the whole column sideways. The chart's delta row is the one
exception — it rolls from zero, because zero change is the honest starting
point for a delta and that row has neither a `FittedBox` nor end alignment to
fight.

### Mount-triggered vs scroll-triggered

An entrance below the fold that plays on mount has finished before the reader
ever reaches it, which is the same as having no animation at all. Anything that
can start off-screen therefore passes `revealOnScroll: true`.

| Content | Trigger |
|---|---|
| AUM hero and its chart | Mount — always the first thing on screen |
| Dashboard sections below it | Scroll |
| Recent-transaction rows and footer | Scroll — the card sits at the bottom of the dashboard |
| Allocation legend rows | Scroll |
| Total Commissions hero value | Scroll — the card sits below the fold |
| Account and household row figures, and their allocation bars | Scroll |
| Account and household rows | Scroll — a lazy list builds rows a screenful early, so mount would play them unseen |
| Insight and view-transaction rows | Mount |

The trigger fires once per mount, not once per lifetime. A lazy `ListView`
disposes rows leaving its cache extent and rebuilds them on return, resetting
it. This is why the dashboard is a `SingleChildScrollView`: its children stay
mounted, so each section's entrance genuinely plays once. Do not convert it to
a lazy list without revisiting that.

### Where motion is deliberately absent

- **Tab switching** does not crossfade. Wrapping `StatefulNavigationShell`
  destroys the `IndexedStack` state and scroll position each branch preserves.
- **List and detail screens share no `Hero`.** The list card and the detail
  header share no geometry, so a shared-element flight stretches rather than
  transforms.
- **Notification rows are not staggered.** They sit inside one `ClipRRect` card,
  so a per-row rise slides under its edge. The section crossfades instead.
- **The dashboard has no scroll parallax.** It would fight `RefreshIndicator`.
- **Chart touch does not animate anything.** Hovering a point rewrites the hero
  value and the delta row; both land immediately by design.

### Open verification

The allocation donut now draws as a clock-hand sweep rather than every slice
growing at once. At progress zero every section value is zero, which is what
the previous implementation also did on its first frame, so `fl_chart` is known
to tolerate a zero-sum pie — but the new sweep's pace across an allocation set
that does not total 100 is worth a look.

The skeleton-to-data `AnimatedSwitcher` crossfades have not been checked on a
device — project rules forbid booting a simulator to verify UI. During the
crossfade the switcher sizes to the taller of the two children, so a shimmer
and its content differing in height produce a small settle at the swap. The
skeletons in this codebase are hand-matched to content line heights, so the
difference should be sub-pixel, but this is the kind of thing only a real
device shows. Confirm it during the next manual pass on the dashboard,
accounts, households, real-time, insights and transactions screens.

---

## Rules

- **Widgets read from `colorScheme`**, not from `AppColors` directly, for any color with a semantic M3 role (`onSurface`, `surface`, `primary`, `outlineVariant`, `error`).
- **`AppColors` is only imported** in `app_theme.dart`, `app_typography.dart`, and widgets that need a color with no M3 equivalent (`logoBlue`, `cardBorder`, `cardBlurOverlay`, `footerText`, `subtitleText`).
- **Never call `ScaffoldMessenger` directly** — use `snackbarServiceProvider`.
- **Never hardcode icon SVGs** — use `Iconify(Mdi.*)` with static MDI strings.
- **Never pass a raw `Duration` to an animation widget** — use
  `AppMotion.duration(context, …)` so "reduce motion" is honoured.
- **Never wrap an inert widget in `Pressable`** — the dip must correspond to a
  real tap handler.
- **Never give `FigureReveal` a `replayKey` that changes on touch** — the roll
  would restart faster than it can finish.
- **Never use `SlideIn` without wrapping its region in a matching `SlideInClip`**
  — the child is drawn 150% of its width outside its box on the first frame,
  and a `ClipRect` would cut its overshoot.
- **Reach for `SettleIn` first.** `SlideIn` is the exception, not a second
  default; more than one lively entrance on a screen reads as noise.
