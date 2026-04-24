// Waves Iridescent Shader - Rippling gradients
// Cavalry-compatible GLSL version
// Purple-pink spectrum with smooth wave motion

precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse; // Mouse position (0-1 range)
uniform float u_grain; // Grain amount (0-1 range)

// Smooth purple-pink interference
vec3 waveInterference(float thickness, float angle) {
    vec3 wavelengths = vec3(670.0, 540.0, 440.0);
    float filmThickness = thickness * 295.0 + 185.0;

    vec3 phase = 4.0 * 3.14159 * filmThickness * cos(angle) / wavelengths;
    vec3 intensity = 0.5 + 0.5 * cos(phase);

    // Purple to pink gradient
    vec3 purple = vec3(0.48, 0.28, 0.76);
    vec3 pink = vec3(0.92, 0.72, 0.88);
    vec3 tint = mix(purple, pink, smoothstep(0.2, 0.8, thickness));

    return intensity * tint;
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;

    float time = u_time * 0.18;

    // Mouse creates ripple origin
    vec2 mousePos = mix(vec2(0.5, 0.5), u_mouse, 0.3);

    // Rippling waves from mouse area
    float dist = distance(uv, mousePos);

    // Multiple smooth wave layers
    float wave1 = sin(dist * 8.0 - time * 2.5);
    float wave2 = sin(dist * 6.0 + time * 2.0);
    float wave3 = cos(dist * 10.0 - time * 1.8);

    // Combine waves smoothly
    float thickness = (wave1 + wave2 + wave3) * 0.15 + 0.5;
    thickness = smoothstep(0.0, 1.0, thickness);

    // Mouse adds directional influence
    vec2 mouseInfluence = (u_mouse - 0.5) * 2.0;
    float directional = sin(uv.x * 5.0 + mouseInfluence.x * 2.0 + time) *
                        cos(uv.y * 5.0 + mouseInfluence.y * 2.0 - time * 0.8);
    thickness += directional * 0.1;

    // Smooth viewing angle
    float angle = dist * 1.4 + time * 0.2;

    vec3 rgb = waveInterference(thickness, angle);
    rgb = rgb * 0.87 + 0.13;

    // Add film grain
    if (u_grain > 0.0) {
        float grain = fract(sin(dot(uv * 1000.0 + time * 0.1, vec2(12.9898, 78.233))) * 43758.5453);
        grain = (grain - 0.5) * u_grain * 0.15;
        rgb += grain;
    }

    gl_FragColor = vec4(rgb, 1.0);
}
