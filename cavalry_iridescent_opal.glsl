// Opal Iridescent Shader - Vibrant multi-color shifts
// Cavalry-compatible GLSL version
// Thin film interference simulation

precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse; // Mouse position (0-1 range)
uniform float u_grain; // Grain amount (0-1 range)

// Thin film interference for purple-pink spectrum
vec3 thinFilmColor(float thickness, float angle) {
    vec3 wavelengths = vec3(640.0, 510.0, 460.0);
    float filmThickness = thickness * 320.0 + 190.0;

    vec3 phase = 4.0 * 3.14159 * filmThickness * cos(angle) / wavelengths;
    vec3 intensity = 0.5 + 0.5 * cos(phase);

    // Purple to pink gradient
    vec3 purple = vec3(0.50, 0.30, 0.72);
    vec3 pink = vec3(0.90, 0.70, 0.85);
    vec3 tint = mix(purple, pink, thickness);

    return intensity * tint;
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;

    float time = u_time * 0.15;

    // Create flowing thickness variation influenced by mouse
    float thickness = sin(uv.x * 8.0 + time * 2.0 + u_mouse.x * 3.0) *
                      cos(uv.y * 6.0 - time * 1.5 + u_mouse.y * 3.0) * 0.5 + 0.5;

    // Add multiple layers of noise for complexity
    float noise1 = sin(uv.x * 12.0 + uv.y * 10.0 + time);
    float noise2 = cos(uv.x * 8.0 - uv.y * 15.0 - time * 0.7);
    thickness += (noise1 + noise2) * 0.15;

    // Viewing angle variation from mouse position
    float angle = length(uv - u_mouse) * 1.5;

    // Calculate interference colors
    vec3 rgb = thinFilmColor(thickness, angle);

    // Ensure it stays light and bright
    rgb = rgb * 0.88 + 0.12;

    // Add film grain
    if (u_grain > 0.0) {
        float grain = fract(sin(dot(uv * 1000.0 + time * 0.1, vec2(12.9898, 78.233))) * 43758.5453);
        grain = (grain - 0.5) * u_grain * 0.15;
        rgb += grain;
    }

    gl_FragColor = vec4(rgb, 1.0);
}
