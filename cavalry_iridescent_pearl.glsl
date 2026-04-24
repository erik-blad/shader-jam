// Pearl Iridescent Shader - Mother of pearl effect
// Cavalry-compatible GLSL version
// Vibrant interference-based color shifts

precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse; // Mouse position (0-1 range)
uniform float u_grain; // Grain amount (0-1 range)

// Thin film interference for purple-pink spectrum
vec3 pearlInterference(float thickness, float angle) {
    vec3 wavelengths = vec3(650.0, 520.0, 450.0);
    float filmThickness = thickness * 280.0 + 180.0;

    vec3 phase = 4.0 * 3.14159 * filmThickness * cos(angle) / wavelengths;
    vec3 intensity = 0.5 + 0.5 * cos(phase);

    // Purple to pink gradient tint
    vec3 purple = vec3(0.55, 0.35, 0.75);
    vec3 pink = vec3(0.85, 0.65, 0.80);
    vec3 tint = mix(purple, pink, thickness);

    return intensity * tint;
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;

    float time = u_time * 0.2;

    // Mouse affects the center point of the effect
    vec2 mousePos = u_mouse;

    // Create flowing thickness variation influenced by mouse
    vec2 warp = vec2(
        sin(uv.y * 3.0 + time + mousePos.x * 2.0) * 0.15,
        cos(uv.x * 3.0 - time * 0.7 + mousePos.y * 2.0) * 0.15
    );

    vec2 warpedUV = uv + warp;

    // Thickness variation
    float thickness = sin(warpedUV.x * 6.0 + time * 1.5) *
                      cos(warpedUV.y * 5.0 - time * 1.2) * 0.5 + 0.5;

    // Add organic noise affected by mouse distance
    float mouseDist = distance(uv, mousePos);
    float noise = sin(warpedUV.x * 10.0 + warpedUV.y * 8.0 + time * 0.8);
    thickness += noise * (0.2 + mouseDist * 0.3);

    // Viewing angle affected by mouse position
    float angle = length(uv - mousePos) * 1.3;

    // Calculate interference colors
    vec3 rgb = pearlInterference(thickness, angle);

    // Keep it bright
    rgb = rgb * 0.85 + 0.15;

    // Add film grain
    if (u_grain > 0.0) {
        float grain = fract(sin(dot(uv * 1000.0 + time * 0.1, vec2(12.9898, 78.233))) * 43758.5453);
        grain = (grain - 0.5) * u_grain * 0.15;
        rgb += grain;
    }

    gl_FragColor = vec4(rgb, 1.0);
}
