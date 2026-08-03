# CSS & Layout Mechanics Vocabulary

*Why the box is the size it is and sits where it sits. (Aesthetics live in the `vocabulary` design skill; this file is the mechanics.)*

**Padding vs margin vs gap** — Padding is space *inside* the border (part of the element, takes its background); margin is space *outside* it; gap is space *between* flex/grid siblings, owned by the container. "Too much space" is a different fix depending on which one it is.

**Margin collapse** — Adjacent vertical margins merge into the larger one instead of adding — but only for block flow, not flex/grid. Why a heading's space "disappears" when you move it into a flex column.

**Box model / box-sizing** — Whether `width` means the content box or includes padding and border. `border-box` (include them) is the sane default everyone resets to.

**Block vs inline** — Block elements stack vertically and take full width; inline elements flow within text and ignore vertical margins. `inline-block` flows like text but accepts box properties.

**Intrinsic vs extrinsic sizing** — Intrinsic: the content decides the size (`min-content`, `max-content`, `fit-content`). Extrinsic: the container decides (`width: 50%`). Modern layout leans intrinsic — let content push, let containers clamp.

**min-content / max-content** — Narrowest the element can get without overflow (longest word wins) vs width if nothing ever wrapped. The vocabulary for "why won't this shrink?" — some child has a large min-content.

**Flex-basis vs width** — Flex-basis is the *starting* size before grow/shrink distribute leftovers; width is a fixed claim. In a flex row, `flex-basis: 0` + `flex-grow: 1` means "share equally regardless of content."

**flex-grow / flex-shrink** — How leftover space is distributed / how deficit is absorbed, proportionally. A child that "refuses to shrink" usually has `flex-shrink: 0` — or a min-content floor (fix with `min-width: 0`).

**Justify vs align** — Justify distributes along the main axis, align along the cross axis. In a row: justify = horizontal, align = vertical. Flip the direction and they flip too — that's the confusion.

**Positioning (static/relative/absolute/fixed/sticky)** — Relative: nudged but keeps its slot. Absolute: removed from flow, anchored to the nearest *positioned* ancestor. Fixed: anchored to the viewport. Sticky: in flow until a scroll threshold, then pinned — needs a scrollable ancestor that doesn't clip it.

**Containing block** — The ancestor a positioned or percentage-sized element measures against. Absolute children anchoring to the wrong thing means the intended parent isn't positioned (`position: relative` fixes it).

**Stacking context** — A group whose children's z-indexes only compete *within* it. Created by transforms, opacity < 1, filters, and more — why `z-index: 9999` still loses: it's trapped inside a lower context.

**Overflow** — What happens when content exceeds the box: visible, hidden, scroll, auto. `overflow: hidden` also clips shadows and sticky children — a frequent silent breaker.

**Aspect-ratio** — Locks width:height so media boxes reserve space before content loads. The modern fix for image-caused layout shift.

**Viewport units (vh/dvh/svh)** — Percent of viewport. Plain `100vh` overshoots on mobile because browser chrome comes and goes; `dvh` tracks the *dynamic* viewport.

**Container query** — Styling by the *parent's* width instead of the viewport's. The right tool when a card must adapt to its slot, not the screen.

**Breakpoint** — A viewport width where layout rules change. Fewer, content-driven breakpoints beat device-name lists; fluid techniques (clamp, grid minmax) reduce how many you need.

**Fluid layout** — Sizes that scale continuously (`clamp()`, `minmax()`, percentages) instead of jumping at breakpoints. "Layout by ratios, not pixels."

**Reflow vs repaint** — Reflow recomputes geometry (expensive, cascades); repaint redraws pixels (cheaper). Animating layout properties (width, top) causes reflow every frame — animate `transform` and `opacity`, which skip both.

**Layout shift (CLS)** — Visible content jumping as late arrivals (images, fonts, ads) push it around. Reserved space (aspect-ratio, width/height attributes) and matched fallback fonts are the fixes.

**Specificity** — The scoring that decides which selector wins: inline > id > class > element. Utility-class systems keep it flat on purpose; a specificity war is a sign someone left the system.

**Cascade layer (@layer)** — Explicit priority tiers for stylesheets, so "reset < framework < utilities" is declared rather than fought over with specificity hacks.

**Custom property vs design token** — A custom property (`--space-4`) is the CSS mechanism; a token is the design *decision* it carries. Tokens over raw values: change the decision once, everything follows.

**Arbitrary value** — Tailwind's escape hatch (`px-[13px]`). One is a question; a pattern of them means a missing token.

**Logical properties** — `margin-inline-start` instead of `margin-left`: direction-aware spacing that survives RTL and vertical writing modes.

**Scroll container** — The element that actually scrolls. Sticky positioning, `overflow-anchor`, and scroll-driven animations all resolve against it — most "sticky doesn't work" bugs are "wrong element is the scroll container."
