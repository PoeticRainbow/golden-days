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

// changed quadratic to cubic for a less dramatic brightness
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
    float sky_level = floor(texCoord.y * 16) * lightmapInfo.SkyFactor / 15;

    float light_level = max(block_level, sky_level);
    // Clamp for potential fix?
    light_level = clamp(light_level, 0.0, 1.0);

    #if QUANTIZE_LIGHT == 1
        light_level = floor(light_level * 15 + 0.5) / 15;
    #endif

    // Calculate grayscale ambient light level
    #if OVERRIDE_AMBIENT == 1
        float ambient = 0.05;
    #else
        // Vanilla overworld is 0.04, so we correct with 0.01 to match Beta's values
        float ambient = (lightmapInfo.AmbientColor.r + lightmapInfo.AmbientColor.g + lightmapInfo.AmbientColor.b) / 3 + 0.01;
    #endif

    vec3 color = vec3(getBetaLightLevel(light_level, max(ambient, 0.05)));

    // Apply boss overlay darkening effect
    color = mix(color, color * max(light_level, 0.4), lightmapInfo.BossOverlayWorldDarkeningFactor);

    // Apply darkness effect scale
    color = color - vec3(lightmapInfo.DarknessScale);

    // Apply brightness
    color = clamp(color, 0.0, 1.0);
    vec3 notGamma = notGamma(color);
    color = mix(color, notGamma, lightmapInfo.BrightnessFactor);

    // Night vision
    if (lightmapInfo.NightVisionFactor > 0.0) {
        color = color + lightmapInfo.NightVisionColor * lightmapInfo.NightVisionFactor;
    }

    fragColor = vec4(color, 1.0);
    return;
}
