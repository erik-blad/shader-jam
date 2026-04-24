// Flow Iridescent Shader - Complex layered interference
// Cavalry-compatible GLSL version
// Purple-pink spectrum with intricate organic movement

precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse; // Mouse position (0-1 range)
uniform float u_grain; // Grain amount (0-1 range)

// Smooth hash for noise
float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

// Smooth value noise - no hard edges
float smoothNoise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f); // Smoothstep interpolation

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

// Fractal noise with multiple octaves
float fractalNoise(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;

    for(int i = 0; i < 4; i++) {
        value += amplitude * smoothNoise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }

    return value;
}

// Complex multi-layer interference
vec3 flowInterference(float thickness, float angle, float layer) {
    vec3 wavelengths = vec3(655.0, 525.0, 445.0);
    float filmThickness = thickness * 290.0 + 190.0 + layer * 30.0;

    vec3 phase = 4.0 * 3.14159 * filmThickness * cos(angle) / wavelengths;
    vec3 intensity = 0.5 + 0.5 * cos(phase);

    // Smooth purple to pink transition
    float blend = thickness * 0.5 + 0.5; // Normalize to 0-1
    blend = smoothstep(0.0, 1.0, blend); // Extra smoothing

    vec3 purple = vec3(0.50, 0.30, 0.75);
    vec3 pink = vec3(0.90, 0.70, 0.85);
    vec3 tint = mix(purple, pink, blend);

    return intensity * tint;
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;

    float time = u_time * 0.3; // Increased time speed

    // Mouse creates flowing distortion field
    vec2 mouseInfluence = (u_mouse - 0.5) * 0.5;

    // Add strong rotation to UV coordinates
    vec2 center = vec2(0.5, 0.5);
    vec2 centeredUV = uv - center;

    // Much faster rotation based on time and distance
    float distFromCenter = length(centeredUV);
    float rotation = time * 0.8 + distFromCenter * 2.5; // Much faster rotation

    float cosR = cos(rotation);
    float sinR = sin(rotation);
    vec2 rotatedUV = vec2(
        centeredUV.x * cosR - centeredUV.y * sinR,
        centeredUV.x * sinR + centeredUV.y * cosR
    ) + center;

    // Add secondary rotation layer for more movement
    float rotation2 = -time * 0.4 + distFromCenter * 1.2;
    float cosR2 = cos(rotation2);
    float sinR2 = sin(rotation2);
    vec2 doubleRotatedUV = vec2(
        rotatedUV.x * cosR2 - rotatedUV.y * sinR2,
        rotatedUV.x * sinR2 + rotatedUV.y * cosR2
    );

    // Use double-rotated UV for calculations
    uv = doubleRotatedUV;

    // Multiple flowing centers that also rotate
    float centerRotation = time * 0.5;
    vec2 center1 = vec2(0.5, 0.5) + vec2(
        sin(time * 0.6 + centerRotation + mouseInfluence.x * 1.5) * 0.2,
        cos(time * 0.8 + centerRotation + mouseInfluence.y * 1.5) * 0.2
    );

    vec2 center2 = vec2(0.5, 0.5) + vec2(
        cos(time * 0.7 - centerRotation - mouseInfluence.y * 1.2) * 0.18,
        sin(time * 0.9 + centerRotation + mouseInfluence.x * 1.2) * 0.16
    );

    vec2 center3 = vec2(0.5, 0.5) + vec2(
        sin(time * 0.55 + centerRotation * 0.8 + mouseInfluence.x * 0.9) * 0.22,
        cos(time * 0.75 - centerRotation * 0.8 - mouseInfluence.y * 0.9) * 0.19
    );

    // Smooth distance calculations
    float dist1 = distance(uv, center1);
    float dist2 = distance(uv, center2);
    float dist3 = distance(uv, center3);

    // Smooth combined distance field
    float distField = (dist1 + dist2 * 0.7 + dist3 * 0.5) / 2.2;

    // Rotating angle calculations
    float angle1 = atan(uv.y - center1.y, uv.x - center1.x) + time * 0.6;
    float angle2 = atan(uv.y - center2.y, uv.x - center2.x) - time * 0.5;

    // Rotating fractal noise layers
    float noise1 = fractalNoise(uv * 2.5 + vec2(cos(time * 0.3), sin(time * 0.3)) * 0.5);
    float noise2 = fractalNoise(uv * 3.8 + vec2(sin(time * 0.25), cos(time * 0.25)) * 0.4);
    float noise3 = fractalNoise(uv * 5.2 + vec2(cos(time * 0.2), -sin(time * 0.2)) * 0.3);

    // Faster rotating wave patterns
    float wave1 = sin(dist1 * 6.0 - time * 3.5 + angle1 * 2.0) * 0.25;
    float wave2 = sin(dist2 * 4.5 + time * 3.0 - angle2 * 1.5) * 0.2;
    float wave3 = sin(dist3 * 7.5 - time * 2.8 + angle1 * 1.3) * 0.18;

    // Gentle flow field from mouse
    vec2 flowUV = uv + vec2(
        sin(uv.y * 4.0 + mouseInfluence.x * 3.0 + time) * 0.03,
        cos(uv.x * 4.0 + mouseInfluence.y * 3.0 - time * 0.8) * 0.03
    );

    // Additional smooth noise on flow field
    float flowNoise = fractalNoise(flowUV * 6.0 + time * 0.1);

    // Combine everything smoothly
    float thickness = 0.5 +
                     wave1 + wave2 + wave3 +
                     noise1 * 0.15 +
                     noise2 * 0.12 +
                     noise3 * 0.1 +
                     flowNoise * 0.08;

    // Smooth it out even more
    thickness = smoothstep(0.2, 0.8, thickness);

    // Multiple smooth viewing angles
    float viewAngle = distField * 1.2 +
                     sin(time * 0.35 + noise1) * 0.15 +
                     cos(time * 0.28 - noise2) * 0.12;

    // Layer multiple interference patterns with smooth blending
    vec3 rgb = vec3(0.0);
    rgb += flowInterference(thickness, viewAngle, 0.0) * 0.38;
    rgb += flowInterference(thickness * 0.9 + 0.15, viewAngle * 0.92, 1.0) * 0.34;
    rgb += flowInterference(thickness * 1.1 - 0.1, viewAngle * 1.08, 2.0) * 0.28;

    // Normalize and brighten
    rgb = rgb * 0.88 + 0.12;
    rgb = smoothstep(0.0, 1.0, rgb); // Final smoothing pass

    // Add film grain
    if (u_grain > 0.0) {
        float grain = fract(sin(dot(uv * 1000.0 + time * 0.1, vec2(12.9898, 78.233))) * 43758.5453);
        grain = (grain - 0.5) * u_grain * 0.15;
        rgb += grain;
    }

    gl_FragColor = vec4(rgb, 1.0);
}
