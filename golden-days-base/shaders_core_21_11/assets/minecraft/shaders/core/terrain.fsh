#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:globals.glsl>
#moj_import <minecraft:chunksection.glsl>

#moj_import <golden_days:general.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;

out vec4 fragColor;

// proper nearest-neighbor sampling, fixes smooth edges of pixels on the inside of faces just like old
vec4 sampleNearest(sampler2D source, vec2 uv, vec2 pixelSize, vec2 du, vec2 dv, vec2 texelScreenSize) {
    // redirect
    return goldenDaysTexture(source, uv, pixelSize);
}

vec4 sampleNearest(sampler2D source, vec2 uv, vec2 pixelSize) {
    // redirect
    return goldenDaysTexture(source, uv, pixelSize);
}

// Rotated Grid Super-Sampling
vec4 sampleRGSS(sampler2D source, vec2 uv, vec2 pixelSize) {
    // redirect
    return goldenDaysTexture(source, uv, pixelSize);
}

void main() {
    vec4 color = goldenDaysTexture(Sampler0, texCoord0, TextureSize) * vertexColor;
#ifdef ALPHA_CUTOUT
    if (color.a < ALPHA_CUTOUT) {
        discard;
    }
#endif
    fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}
