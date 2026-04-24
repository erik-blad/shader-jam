# Light Iridescent SKSL Shaders

Four variations of light-colored iridescent shaders for SKSL (Skia Shader Language).

## Shaders

### 1. **iridescent_pastel.sksl** - Soap Bubble Effect
- Soft, dreamy pastel colors
- Multiple wave layers for depth
- Smooth color transitions across the spectrum
- Best for: backgrounds, overlays, dreamy effects

### 2. **iridescent_pearl.sksl** - Mother of Pearl
- Subtle shifts between pink, blue, cream, and lavender
- Fresnel-based viewing angle simulation
- Subtle sparkle effect
- Best for: elegant UI elements, refined backgrounds

### 3. **iridescent_opal.sksl** - Thin Film Interference
- Simulates actual light interference physics
- More vibrant color shifts
- Flowing thickness variations
- Best for: dynamic effects, high-energy visuals

### 4. **iridescent_simple.sksl** - Easy to Customize
- Clean gradient-based approach
- Four color stops you can easily modify
- Radial and angular color distribution
- Best for: learning, customization, simple effects

## Usage

All shaders require these uniforms:
```glsl
uniform float2 iResolution; // Canvas resolution (width, height)
uniform float iTime;         // Time in seconds for animation
```

## Customization Tips

### Adjusting Colors
Modify the RGB values (range 0.0-1.0):
```glsl
float3 color1 = float3(0.95, 0.85, 0.95); // R, G, B
```

### Speed
Change time multipliers:
```glsl
float time = iTime * 0.3; // Slower: 0.1, Faster: 0.5
```

### Pattern Scale
Adjust the multipliers in sin/cos functions:
```glsl
sin(uv.x * 10.0) // Smaller: 5.0, Larger: 20.0
```

### Brightness
Adjust the final RGB values:
```glsl
rgb = rgb * 0.9 + 0.1; // Lighter or darker
```

## Integration Example (Flutter)

```dart
CustomPaint(
  painter: ShaderPainter(
    shader: fragmentShader,
    time: elapsed,
  ),
  size: Size.infinite,
)
```

Enjoy your iridescent shaders!
