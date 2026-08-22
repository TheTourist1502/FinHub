# Animation & Motion Rules

Motion in this app has one job: make an advisor's money legible as it arrives.
It is never decoration. If a change reads fine without motion, ship it without
motion.

## Where motion lives

- Durations and curves: `lib/core/motion/app_motion.dart` (`AppMotion`).
- Reusable animation widgets: `lib/shared/animations/`.
- A one-off animation belonging to a single feature stays in that feature's
  `presentation/widgets/`, but still reads its timings from `AppMotion`.
- Never write a `Duration(milliseconds: …)` or a `Curves.…` literal in a
  feature widget. Use an `AppMotion` token; if none fits, add one there with a
  `///` comment saying what it is for.
- `lib/shared/animations/animation.txt` is the RedStar CSS reference used for
  inspiration only. Port a keyframe sequence into a Dart widget (see
  `slide_in.dart`); never treat the file as a spec to implement wholesale.

## The master switch

`isAnimationApplicable` in `lib/shared/animations/animations.dart` turns every
animation in that folder on or off. `true` ships them; `false` renders each one's
finished frame on the first pump.

- Widgets **inside** `lib/shared/animations/` call `animationsEnabled(context)`
  and `animationDuration(context, …)`, never `AppMotion.enabled` /
  `AppMotion.duration` directly — that indirection is the whole switch.
- Everything else (an `AnimatedSwitcher` in a feature widget, the history
  chart's tween, route transitions) keeps calling `AppMotion` and is *not*
  covered. Do not widen the switch by making `AppMotion` read it: `core/` must
  not import from `shared/`.
- It is not a user setting. Reduce motion already is one, and both gates are
  checked independently.

## Reduce motion — non-negotiable

Every animation must honour the platform's "reduce motion" setting.

- Implicit widgets (`AnimatedContainer`, `AnimatedOpacity`, `AnimatedSwitcher`,
  `AnimatedScale`, …): wrap the duration in `AppMotion.duration(context, …)` —
  or `animationDuration(context, …)` inside `lib/shared/animations/`.
- Explicit controllers: pin the controller at its end value in
  `didChangeDependencies`, not in `build`:
  ```dart
  if (!animationsEnabled(context)) _controller.value = 1;
  ```
- Never branch the widget tree on it. Pinning the controller already renders the
  finished frame; a second code path is a second bug.
- Content must never depend on an animation completing to become visible or
  tappable. A reveal that never fires is invisible content, not a missing
  animation — see the no-`Scrollable`-ancestor fallback in
  `OnScrolledIntoView`.

## Performance budget

The rules below are what keep motion off the frame budget. Follow them and no
profiling session is needed; break one and jank is the default.

- **Never rebuild a subtree per frame.** Hoist it into the `child:` of
  `AnimatedBuilder` / `TweenAnimationBuilder` / a `*Transition` widget so only
  the opacity/offset is recomputed. A `builder:` that constructs the subtree
  every tick rebuilds the whole card 60–120×/second.
- **Never drive an animation with `setState` per frame.** `setState` on a
  discrete state flip (pressed / not pressed, as in `Pressable`) is fine.
- **Animate paint, not layout.** `Transform`, `Opacity`, `FractionalTranslation`
  and the `*Transition` widgets repaint only. Animating padding, width, flex or
  text scale relayouts the subtree every frame — never do it inside a list.
- **One controller per region, not per figure.** A display with an amount and a
  percentage uses one `FigureReveal` whose progress drives both; two controllers
  drift apart *and* cost twice the tickers. Same for shimmer: one controller
  feeding many placeholders.
- **`SingleTickerProviderStateMixin` and always `dispose()` the controller.**
  Use `TickerProviderStateMixin` only when a widget genuinely owns two clocks.
- **No repeating animation outside a real loading state.** A `..repeat()`
  controller keeps the vsync loop awake and drains battery forever. Shimmer
  while data is in flight is the only sanctioned case, and it must be torn down
  when the data lands.
- **No timers for delays.** Fold a stagger delay into the controller's own
  duration as a leading `Interval` (see `SettleIn`), so there is no pending
  callback to cancel on dispose.
- **Entrances are skipped under a fling.** `OnScrolledIntoView` measures scroll
  speed and hands `onVisible` an `animate: false` when the list is moving faster
  than `_maxRevealSpeed` (2 viewports/second — about one viewport per entrance
  duration). Past that the row leaves the screen before it has arrived, so a
  played entrance is just a smear trailing the finger. Every `onVisible`
  implementation must honour it by pinning its controller to its end value —
  never by declining to reveal, which would leave the row invisible.
- **Cap staggers at roughly one screenful** (`_maxStaggerSlots`, 8). Past the
  cap a row still animates, but with **no** delay — a stagger choreographs a
  group arriving together, and a row the reader scrolled down to on its own has
  no group to wait for. Never let a capped row inherit the *longest* delay:
  that leaves it blank under the reader for half a second. Dropping the
  entrance entirely past the cap is also wrong now that the fling gate above
  measures the real scroll speed.
- **`revealOnScroll: true` for anything that can start below the fold.**
  Otherwise the entrance is finished before the reader ever scrolls to it, which
  costs frames and delivers nothing.
- **`RepaintBoundary` only around a continuously animating widget inside a large
  static subtree.** Elsewhere it adds a layer and buys nothing.
- **No `BackdropFilter` or blur inside anything that animates.** Blur is a
  per-frame full-region GPU pass; it is affordable on a static dialog scrim and
  nowhere else.
- Entrance animations run **once per mount**. Refreshing data must not remount
  the section — pull-to-refresh updates in place, it does not replay the app.

## The motion language

- **Entrances:** `SettleIn`. Fade plus a 12 px rise, `AppMotion.enter`. This is
  the default for sections and list rows; reach for anything else only with a
  reason.
- **Livelier entrance:** `SlideIn` (with a `SlideInClip` of the same
  `direction`). The four `SlideDirection`s are the ported `slideLeft` /
  `slideRight` / `slideUp` / `slideDown` keyframes — named after the source
  sequences, so `.left` moves leftward and therefore *enters from the right*,
  and `.up` enters from below. Reserved for a single element arriving beside or
  below something else: an allocation legend next to its donut, the dashboard's
  quick-action bar under the AUM header. Applying it broadly puts the whole
  screen in motion at once. Its overshoot means it never wraps a figure.
- **Proportion bars:** `Wipe`, driven by the same `FigureReveal` as any figures
  beside it. Uncovers left to right by clipping, so the segments never render
  at a width that misstates their value. Never reveal a bar by tweening its
  flex or width — that relayouts every frame *and* lies about the proportion
  until the last one.
- **Loading → data:** `AnimatedSwitcher` at `AppMotion.base`, crossfading a
  skeleton into content. Give the branches distinct keys/types so the switcher
  sees a change.
- **Figures:** `FigureReveal` at `AppMotion.hero` for a hero value,
  `AppMotion.settle` for secondary figures so they do not compete.
- **Press feedback:** `Pressable`. It uses `Listener`, not `GestureDetector`, so
  the card's own `InkWell` keeps its tap callback and ripple — never wrap a
  tappable in a second competing gesture detector.
- **Screen transitions:** owned by `pageTransitionsTheme` in `app_theme.dart`
  (iOS push on both platforms). Do not hand-roll a route transition per screen.

## Money does not bounce

- No `Curves.elasticOut`, `bounceOut`, spring simulation, or overshoot on any
  balance, figure, chart value, or number the advisor reads. Use
  `AppMotion.enter` / `settleCurve`. Overshoot exists in exactly one place —
  `SlideIn`'s ported keyframes — and stays there, where it moves a *label*
  rather than a figure. This is why the allocation donut's entrance grows its
  highlighted slice with `AppMotion.enter` instead of popping it in with the
  source's `fadeIn` scale overshoot: the ring is a value the advisor reads.
- A figure that tracks a gesture (chart scrub, drag) must never restart its
  roll while the finger moves; `FigureReveal.replayKey` takes a genuine reason
  to replay (a filter change), never the value itself.
- Motion never gates interaction. Taps, scrolls and back gestures must work
  mid-animation.

## Tests

Every widget in `lib/shared/animations/` needs a widget test in
`test/shared/animations/` covering three things (see `settle_in_test.dart`):

1. Reduce motion on → the final frame is rendered on the **first** pump.
2. Motion on → a distinct start state, then the resting state after
   `pumpAndSettle`.
3. Any escape hatch the widget has — a stagger cap, a `replayKey`, a one-shot
   guard — asserted directly.

`pumpAndSettle` must return; if it times out, something is repeating that
should not be.
