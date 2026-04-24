# Cavalry GLSL Shaders - Iridescent Purple-Pink Collection

Four smooth, gradient-based iridescent shaders optimized for Cavalry with a purple-pink color palette.

## Files

- `cavalry_iridescent_pearl.glsl` - Organic flowing warps
- `cavalry_iridescent_opal.glsl` - Direct mouse control
- `cavalry_iridescent_flow.glsl` - Smooth flowing gradients
- `cavalry_iridescent_waves.glsl` - Rippling wave motion

## Color Palette

All shaders use a **purple to pink gradient spectrum**:
- Deep purples (#8B5AA8)
- Lavender tones
- Soft pinks (#E8B8D4)
- Blue-purple undertones

No hard edges - all transitions are smooth and organic.

## Key Features

1. **Uniforms** - Cavalry-compatible:
   - `u_resolution` - Canvas resolution (width, height)
   - `u_time` - Time in seconds
   - `u_mouse` - Mouse position (0-1 range)
   - `u_grain` - Film grain amount (0-1 range)

2. **Mouse Reactivity**:
   - **Pearl** & **Opal**: Direct mouse control for responsive interaction
   - **Flow** & **Waves**: Gentle mouse influence with organic auto-movement

3. **Film Grain**: All shaders support adjustable film grain for texture

## How to Use in Cavalry

1. Open Cavalry
2. Create a new Shape or Layer
3. In the Attributes panel, find the **Material** section
4. Add a **Custom Shader**
5. Copy and paste the entire shader code from one of the `.glsl` files
6. The shader will automatically animate

## Uniforms Setup

Cavalry automatically provides:
- `u_resolution` - Automatically set
- `u_time` - Automatically set
- `u_mouse` - Requires mouse tracking setup in Cavalry
- `u_grain` - Set manually (0.0 = no grain, 1.0 = maximum grain)

## Customization

### Adjust Animation Speed
```glsl
float time = u_time * 0.2; // Slower: 0.1, Faster: 0.5
```

### Modify Color Spectrum
Edit the purple/pink values in the interference functions:
```glsl
vec3 purple = vec3(0.55, 0.35, 0.75); // R, G, B
vec3 pink = vec3(0.85, 0.65, 0.80);   // R, G, B
```

### Adjust Grain Amount
In Cavalry, set the `u_grain` uniform:
- `0.0` - No grain
- `0.3` - Subtle film grain
- `0.5` - Medium grain
- `1.0` - Heavy grain

### Pattern Scale
Adjust multipliers in wave calculations:
```glsl
sin(dist * 8.0) // Smaller: 4.0, Larger: 16.0
```

## Shader Descriptions

### Pearl (Organic Flow)
- Flowing thickness with organic warping patterns
- Mouse directly controls warp offset and viewing angle
- Smooth, continuous color shifts
- Best for: Elegant backgrounds, refined UI

### Opal (Direct Control)
- Vibrant color shifts with direct mouse control
- Mouse affects thickness waves and viewing angle
- Most responsive to interaction
- Best for: Interactive elements, high-energy visuals

### Flow (Complex Layered)
- Multi-layered interference with 3 flowing centers
- Complex organic noise and wave patterns
- Mouse creates flowing distortion fields
- Most intricate and visually rich
- Best for: Standout backgrounds, artistic effects

### Waves (Rippling Motion)
- Multiple smooth wave layers
- Mouse creates ripple origins and directional influence
- Gentle, water-like motion
- Best for: Dynamic overlays, soft animations

## Performance Tips

- All shaders use `mediump` precision for optimal performance
- For higher quality: change `precision mediump float;` to `precision highp float;`
- Grain adds minimal performance cost
- Mouse reactivity is efficient and real-time

## Browser Testing

Open `test_shaders.html` in a browser to preview all shaders:
- Full-screen canvas
- Translucent button controls
- Live grain slider
- Real-time mouse interaction

Move your mouse to see the effects!

## Design Philosophy

These shaders prioritize:
- **Smooth transitions** - no hard edges or clipping
- **Organic movement** - natural, flowing patterns
- **Consistent color palette** - purple-pink spectrum throughout
- **Interactive feedback** - responsive to mouse with varying degrees of control

Perfect for creating elegant, modern UI backgrounds and effects in Cavalry!
