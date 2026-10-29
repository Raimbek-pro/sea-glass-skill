---
name: sea-glass
description: >-
  Build tactile, sand-tumbled frosted glass UI across Web (HTML, JavaScript, React, Vue)
  and Android/Multiplatform (Jetpack Compose, Compose Multiplatform) using the Sea Glass library.
  Use when creating frosted glass, translucent cards, tumbled buttons, organic pebble surfaces,
  or volumetric Oklab tinting in any web or mobile project.
---

# Universal Sea Glass Design & Implementation Skill

Sea Glass (`dev.mttmcknn:sea-glass` and `sea-glass.mjs`) is an optical graphics foundation that simulates the physical optics of real ocean-tumbled beach glass across **both Web and Mobile/Compose**.

Unlike flat alpha overlays or basic Gaussian blurs, Sea Glass simulates:
- **Procedural Micro-Grain**: Micro-abrasions computed at display resolution with continuous cubic B-spline contours.
- **Volumetric Body Absorption (Oklab)**: Beer-Lambert transmittance coloring—thick borders absorb pigment deeply while highlights remain clear.
- **Transmitted Light & Cast Shadows**: Soft refractive rim catches and colored ground halos extending ~48px/dp around the piece.
- **Cross-Platform Parity**: Identical optical parameters across Web (`Canvas2D`/`ResizeObserver`) and Android (`RuntimeShader`/`AGSL`/Skia).

---

## 1. Web Implementation (HTML, JavaScript, React, Vue)

The web library lives in `sea-glass.mjs` and mounts directly under any standard DOM element without intercepting interactions or layout.

### A. Core Web API: `mountGlass(element, options)`

```javascript
import { mountGlass, PALETTES, DEFAULT_SETTINGS } from './sea-glass.mjs';

const glass = mountGlass(element, {
  shape: 'rounded',    // 'rounded' | 'capsule' | 'disc'
  palette: 'lagoon',   // 'lagoon' | 'lilac' | 'rose' | 'amber' | 'mint' | custom object
  seed: 42,            // Deterministic contour shape
  settings: {
    frost: 0.55,       // Cloudiness (0..1)
    grain: 0.48,       // Micro-abrasion roughness (0..1)
    tumble: 0.025,     // B-spline contour asymmetry (0..0.065)
    thickness: 6,      // Optical thickness (0..14 px)
    bulge: 0.65,       // Curvature through center (0..1)
    elevation: 8,      // Shadow lift (0..18 px)
    light: 315,        // Surface specular azimuth angle (0..360)
    transmission: 0.58 // Lower light pool transmission (0..1)
  }
});

// Update settings or palette live:
glass.update({ elevation: 4 }, 'mint');

// Cleanup on unmount:
glass.destroy();
```

### B. Declarative HTML Pattern
In HTML, add `data-glass` and configure via data attributes:

```html
<!-- Frosted Button -->
<button class="glass" data-glass data-shape="capsule" data-palette="lagoon" data-seed="12">
  Save Moment
</button>

<!-- Frosted Card -->
<article class="glass" data-glass data-shape="rounded" data-palette="mint" data-seed="33">
  <h3>Sanctuary</h3>
  <p>Content floats clearly above the frosted glass body.</p>
</article>
```

#### Auto-hydration Script:
```javascript
import { mountGlass } from './sea-glass.mjs';

document.querySelectorAll('[data-glass]').forEach(el => {
  const shape = el.dataset.shape || 'rounded';
  const palette = el.dataset.palette || 'lagoon';
  const seed = Number(el.dataset.seed) || 42;
  const renderer = mountGlass(el, { shape, palette, seed });

  // Add tactile give on press:
  el.addEventListener('pointerdown', () => renderer.update({ elevation: 2 }));
  const restore = () => renderer.update({ elevation: 7 });
  el.addEventListener('pointerup', restore);
  el.addEventListener('pointerleave', restore);
});
```

### C. Web CSS Guidelines
```css
.glass {
  position: relative;
  isolation: isolate;
  background: transparent;
  border: 0;
  color: var(--glass-ink, #253d36); /* Auto-injected by mountGlass */
  padding: 16px 24px;
}

.glass > canvas.sea-glass-canvas {
  position: absolute;
  pointer-events: none;
  z-index: -1;
  left: -48px;
  top: -48px;
}
```

### D. React Component / Hook
```jsx
import { useEffect, useRef } from 'react';
import { mountGlass } from './sea-glass.mjs';

export function SeaGlass({ children, shape = 'rounded', palette = 'lagoon', seed = 42, ...props }) {
  const ref = useRef(null);
  useEffect(() => {
    if (!ref.current) return;
    const glass = mountGlass(ref.current, { shape, palette, seed });
    return () => glass.destroy();
  }, [shape, palette, seed]);

  return (
    <div ref={ref} className="glass" {...props}>
      {children}
    </div>
  );
}
```

---

## 2. Android & Compose Multiplatform Implementation

### Gradle Dependency
```kotlin
implementation("dev.mttmcknn:sea-glass:0.1.0")
```

### A. Modifier.seaGlass()
Decorate any existing Composable:
```kotlin
Text(
    text = "Tumbled Glass",
    color = palette.ink,
    modifier = Modifier
        .seaGlass(palette = SeaGlassPalette.Lagoon, shape = SeaGlassShape.Rounded)
        .padding(horizontal = 20.dp, vertical = 12.dp)
)
```

### B. SeaGlassSurface & SeaGlassButton
```kotlin
// Container with automatic palette.ink LocalContentColor:
SeaGlassSurface(
    palette = SeaGlassPalette.Mint,
    shape = SeaGlassShape.Rounded,
    style = SeaGlassStyle.Tumbled,
    modifier = Modifier.padding(16.dp)
) {
    Text("Content automatically inherits high-contrast ink")
}

// Tactile Button with physical depress offset & rim highlight:
SeaGlassButton(
    onClick = { /* action */ },
    palette = SeaGlassPalette.Rose,
    shape = SeaGlassShape.Disc
) {
    Icon(Icons.Default.Favorite, contentDescription = "Like")
}
```

### C. Dynamic Material You Integration
```kotlin
val dynamicPalette = SeaGlassPalette.fromColorScheme(
    colorScheme = MaterialTheme.colorScheme,
    role = SeaGlassColorRole.Primary
)
```

---

## 3. iOS & SwiftUI Implementation ("Liquid Glass")

Native SwiftUI integration combining Apple's system blur materials (`.ultraThinMaterial`) with physical Sea Glass optics (volumetric absorption, continuous corner curvature squircles, 315° rim catches, and transmitted ground halos).

### Swift Package Manager (SPM) or Xcode Framework
Open `ios/SeaGlass.xcodeproj` in Xcode or add the `SeaGlass` package:
```swift
dependencies: [
    .package(url: "https://github.com/Raimbek-pro/sea-glass-skill.git", branch: "main")
]
```

### A. View Modifier `.seaGlass()`
Decorate any SwiftUI view:
```swift
Text("Tumbled Glass")
    .font(.system(.body, design: .rounded))
    .padding(.horizontal, 20)
    .padding(.vertical, 12)
    .seaGlass(
        palette: .lagoon,
        shape: .rounded(22),
        elevation: 8,
        frost: 0.55
    )
```

### B. `SeaGlassSurface` & `SeaGlassButton`
```swift
// Container surface with auto-bound ink color & Oklab halo:
SeaGlassSurface(
    palette: .mint,
    shape: .rounded(26),
    elevation: 8,
    frost: 0.6
) {
    VStack(alignment: .leading, spacing: 8) {
        Text("Sanctuary Climate Hub")
            .font(.system(size: 20, weight: .bold, design: .rounded))
        Text("Volumetric pigment with micro-grain texture.")
    }
    .padding(20)
}

// Tactile button with spring depress physics & light haptics:
SeaGlassButton(
    palette: .rose,
    shape: .capsule,
    elevation: 6,
    action: { /* trigger */ }
) {
    HStack(spacing: 8) {
        Image(systemName: "heart.fill")
        Text("Save Moment")
    }
}
```

### C. Continuous Apple Squircle Shapes
- `.rounded(radius)`: Apple continuous curve squircle (`style: .continuous`)
- `.capsule`: Tumbled stadium pill
- `.disc`: Organic rounded pebble circle

---

## 4. Shared Palettes & Optics

Both Web and Compose share the exact same 5 coastal palettes:

| Palette | Body (Translucent Pigment) | Edge (Frosted Rim Catch) | Ink (Text & Icons) |
| :--- | :--- | :--- | :--- |
| **`lagoon` / `Lagoon`** | `#B5D0EB` (Soft Sea Blue) | `#D6E9FF` | `#2F647C` |
| **`mint` / `Mint`** | `#C0DED0` (Coastal Green) | `#E6FFF0` | `#396C5A` |
| **`rose` / `Rose`** | `#EECED6` (Blush Coral) | `#FFF0F1` | `#963F59` |
| **`amber` / `Amber`** | `#F0D9BE` (Warm Honey Beach) | `#FFFCE0` | `#865733` |
| **`lilac` / `Lilac`** | `#E1CDE8` (Soft Violet Drift) | `#FBE8F7` | `#71388B` |

### Shapes
- `rounded` / `SeaGlassShape.Rounded`: Soft worn pebble rectangle
- `capsule` / `SeaGlassShape.Capsule`: Symmetrical stadium pill
- `disc` / `SeaGlassShape.Disc`: Organic tumbled disc/circle

---

## 4. Universal Rules of Thumb
1. **Halo Room**: Always leave ~48px/dp padding around glass components so the soft light pool and cast shadow are never abruptly cropped by an ancestor container.
2. **High-Contrast Ink**: Never hardcode pure white or light grey text over sea glass. Always bind text/icons to `palette.ink` (or `--glass-ink` in CSS) for crisp readability.
3. **Backgrounds**: Sea glass looks most enchanting against organic gradients, coastal tints, or textured backgrounds (where light refraction and Oklab depth can be appreciated).
