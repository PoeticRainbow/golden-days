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

in vec2 texCoord;

out vec4 fragColor;

void main() {
    if (NightVisionFactor > 0.0) {
        fragColor = vec4(vec3(1.0), 1.0);
        return;
    }
    
    float sky_brightness = floor(texCoord.y * 16);
    fragColor = vec4(vec3(clamp(sky_brightness - 13, 0.608, 1)), 1.0);
}
