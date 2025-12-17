#version 330

#define QUANTIZE_LIGHT 0
#define OVERRIDE_AMBIENT 1

layout(std140) uniform LightmapInfo {
    float SkyFactor;
    float BlockFactor;
    float NightVisionFactor;
    float DarknessScale;
    float BossOverlayWorldDarkeningFactor;
    float BrightnessFactor;
    vec3 BlockLightTint;
    vec3 SkyLightColor;
    vec3 AmbientColor;
    vec3 NightVisionColor;
} lightmapInfo;

in vec2 texCoord;

out vec4 fragColor;

// unused
float get_brightness(float level) {
    return pow(level, 2);
}

// unused
vec3 notGamma(vec3 color) {
    float maxComponent = max(max(color.x, color.y), color.z);
    float maxInverted = 1.0f - maxComponent;
    float maxScaled = 1.0f - maxInverted * maxInverted * maxInverted;
    return color * (maxScaled / maxComponent);
}

// unused
float parabolicMixFactor(float level) {
    return (2.0 * level - 1.0) * (2.0 * level - 1.0);
}

float getBetaLightLevel(float light_level, float ambient) {
    // level range [0, 1], ambient range [0, 1]
    float darkness = 1.0 - light_level;
    return (1.0 - darkness) / (darkness * 3.0 + 1.0) * (1.0 - ambient) + ambient;
}

void main() {
    // Calculate block and sky brightness levels based on texture coordinates
    float block_level = floor(texCoord.x * 16) / 15;
    float sky_level = floor(texCoord.y * 16) / 15;

    vec3 color = sky_level < 0.99 && block_level < 0.99 ? vec3(0.6) : vec3(1.0);

    // Apply sky factor
    color = color * lightmapInfo.SkyFactor;

    // Apply boss overlay darkening effect
    color = mix(color, color * 0.6, lightmapInfo.BossOverlayWorldDarkeningFactor);

    // Apply darkness effect scale
    color = color * (1.0 - lightmapInfo.DarknessScale);

    fragColor = vec4(color, 1.0);
}
