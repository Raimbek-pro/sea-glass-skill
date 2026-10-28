# Sea Glass for Android & Compose Multiplatform

Sea Glass provides live GPU-accelerated sand-tumbled physical glass materials for **Jetpack Compose (Android 7.0+)** and **Compose Multiplatform (Desktop / iOS)**.

## Installation

Add to your `build.gradle.kts`:

```kotlin
repositories {
    mavenCentral()
}

dependencies {
    implementation("dev.mttmcknn:sea-glass:0.1.0")
}
```

## Quick Start

### 1. Decorate Any Composable with `Modifier.seaGlass()`
```kotlin
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import dev.mttmcknn.seaglass.SeaGlassPalette
import dev.mttmcknn.seaglass.SeaGlassShape
import dev.mttmcknn.seaglass.seaGlass

@Composable
fun GlassLabel() {
    val palette = SeaGlassPalette.Lagoon
    Text(
        "Tumbled Beach Glass",
        color = palette.ink, // Automatically matched high-contrast text color
        modifier = Modifier
            .seaGlass(palette = palette, shape = SeaGlassShape.Capsule)
            .padding(horizontal = 24.dp, vertical = 14.dp),
    )
}
```

### 2. Tactile Button (`SeaGlassButton`)
Features an authentic physical press depression and frosted rim specular highlight:
```kotlin
import dev.mttmcknn.seaglass.SeaGlassButton
import dev.mttmcknn.seaglass.SeaGlassPalette
import dev.mttmcknn.seaglass.SeaGlassShape

@Composable
fun ActionButton(onAction: () -> Unit) {
    SeaGlassButton(
        onClick = onAction,
        palette = SeaGlassPalette.Mint,
        shape = SeaGlassShape.Capsule
    ) {
        Text("Save Moment")
    }
}
```

### 3. Glass Container (`SeaGlassSurface`)
Self-contained container that automatically sets `LocalContentColor provides palette.ink`:
```kotlin
import dev.mttmcknn.seaglass.SeaGlassSurface
import dev.mttmcknn.seaglass.SeaGlassShape
import dev.mttmcknn.seaglass.SeaGlassStyle

@Composable
fun InfoCard() {
    SeaGlassSurface(
        palette = SeaGlassPalette.Amber,
        shape = SeaGlassShape.Rounded,
        style = SeaGlassStyle.Tumbled,
        modifier = Modifier.padding(16.dp)
    ) {
        Text("Warm beach-glass surface")
    }
}
```

### 4. Dynamic Material You Theming
```kotlin
val palette = SeaGlassPalette.materialTheme()
```
Automatically adopts user wallpaper colors into physical volumetric pigment!
