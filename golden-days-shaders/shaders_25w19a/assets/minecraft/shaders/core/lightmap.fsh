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
    0.05, 0.06666666666666667, 0.08518518518518517, 0.10588235294117646, 0.12916666666666665, 0.15555555555555553, 
    0.18571428571428572, 0.2205128205128205, 0.2611111111111111, 0.309090909090909, 0.36666666666666664, 
    0.43703703703703695, 0.5250000000000001, 0.6380952380952382, 0.7888888888888889, 1.0
);

in vec2 texCoord;

out vec4 fragColor;

int spread(float f, int x) {
    return clamp(int(floor(f * (float(x) + 1.0))), 0, x);
}

void main() {
    if (lightmapInfo.NightVisionFactor > 0.0) {
        fragColor = vec4(vec3(1.0), 1.0);
        return;
    }

    int block_light = spread(texCoord.x, 15);
    int sky_factor = clamp(spread(1.0 - lightmapInfo.SkyFactor, 15), 0, 11);
    int sky_light = clamp(spread(texCoord.y, 15), 0, 15);

    float light = max(BETA_LIGHT[block_light], BETA_LIGHT[sky_light - sky_factor]);
    fragColor = vec4(vec3(clamp(light - lightmapInfo.DarknessScale * 0.7, 0.05, 1.0)), 1.0);
}
