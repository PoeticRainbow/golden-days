#version 150

layout(std140) uniform LightmapInfo {
    float AmbientLightFactor;
    float SkyFactor;
    float BlockFactor;
    int UseBrightLightmap;
    float NightVisionFactor;
    float DarknessScale;
    float DarkenWorldFactor;
    float BrightnessFactor;
    vec3 SkyLightColor;
} lightmapInfo;

const float[] BETA_LIGHT = float[](
    0.05f, 0.06666666666666667f, 0.08518518518518517f, 0.10588235294117646f, 0.12916666666666665f, 0.15555555555555553f, 
    0.18571428571428572f, 0.2205128205128205f, 0.2611111111111111f, 0.309090909090909f, 0.36666666666666664f, 
    0.43703703703703695f, 0.5250000000000001f, 0.6380952380952382f, 0.7888888888888889f, 1.0f
);

in vec2 texCoord;

out vec4 fragColor;

int spread(float f, int x) {
    return clamp(int(floor(f * (float(x) + 1.0f))), 0, x);
}

void main() {
    if (lightmapInfo.NightVisionFactor > 0.0f) {
        fragColor = vec4(vec3(1.0f), 1.0f);
        return;
    }

    int block_light = spread(texCoord.x, 15);
    int sky_factor = clamp(spread(1.0 - lightmapInfo.SkyFactor, 15), 0, 11);
    int sky_light = clamp(spread(texCoord.y, 15), 0, 15);

    float light = max(BETA_LIGHT[block_light], BETA_LIGHT[sky_light - sky_factor]);
    fragColor = vec4(vec3(clamp(light - lightmapInfo.DarknessScale * 0.7f, 0.05f, 1.0f)), 1.0f);
}
