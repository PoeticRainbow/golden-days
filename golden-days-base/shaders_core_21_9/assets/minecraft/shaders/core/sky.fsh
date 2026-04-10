#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

#moj_import <golden_days:general.glsl>

in float sphericalVertexDistance;
in float cylindricalVertexDistance;

out vec4 fragColor;

void main() {
    fragColor = goldenDaysApplySkyFog(ColorModulator, sphericalVertexDistance, FogRenderDistanceEnd, FogEnvironmentalEnd, FogColor);
}
