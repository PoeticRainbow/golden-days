#version 150

uniform float AmbientLightFactor;
uniform float SkyFactor;
uniform float BlockFactor;
uniform int UseBrightLightmap;
uniform vec3 SkyLightColor;
uniform float NightVisionFactor;
uniform float DarknessScale;
uniform float DarkenWorldFactor;
uniform float BrightnessFactor;

const float[] BETA_LIGHT = float[](
    0.05, 0.06666666666666667, 0.08518518518518517, 0.10588235294117646, 0.12916666666666665, 0.15555555555555553, 
    0.18571428571428572, 0.2205128205128205, 0.2611111111111111, 0.309090909090909, 0.36666666666666664, 
    0.43703703703703695, 0.5250000000000001, 0.6380952380952382, 0.7888888888888889, 1.0
);

in vec2 texCoord;

out vec4 fragColor;

float quantize(float f, float x) {
    return floor(f * x) / x;
}

int spread(float f, int x) {
    return clamp(int(floor(f * (x + 1))), 0, x);
}

void main() {
    if (NightVisionFactor > 0.0) {
        fragColor = vec4(vec3(1.0), 1.0);
        return;
    }

    //float time_of_day = clamp((((acos((0.8 - SkyFactor) / 2.0) / 6.2831855) - 0.205) * 17), 0, 1);
    //int sky_factor = clamp(int(floor((time_of_day) * 16)), 4, 15);

    int block_light = spread(texCoord.x, 15);
    int sky_factor = clamp(spread(SkyFactor, 15), 4, 15);
    int sky_light = clamp(spread(texCoord.y, 15), 0, sky_factor);

    float light = BETA_LIGHT[max(block_light, sky_light)];
    fragColor = vec4(vec3(clamp(light - DarknessScale * 0.7, 0.05, 1)), 1.0);
}
