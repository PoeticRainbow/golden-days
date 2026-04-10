#version 330

#moj_import <minecraft:fog.glsl>

#moj_import <golden_days:general.glsl>

in float vertexDistance;
in vec4 vertexColor;

out vec4 fragColor;

void main() {
    fragColor = goldenDaysApplyFog(vertexColor, vertexDistance, FogRenderDistanceEnd, FogEnvironmentalEnd, FogColor);
}
