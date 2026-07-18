#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:oit.glsl>

#moj_import <golden_days:general.glsl>

in float vertexDistance;
in vec4 vertexColor;

#ifndef OIT_ALPHA_ONLY
out vec4 fragColor;
#endif

vec4 calculateFinalColor(vec4 color) {
    #ifdef OIT_ACCUMULATE
    color = sampleColorForAccumulation(color);
    #endif
    return color;
}

void main() {
    vec4 color = vertexColor;
    #ifndef OIT_DEPTH_BOUNDS
    color.a *= 1.0 - linear_fog_value(vertexDistance, 0, FogCloudsEnd);
    #endif

    color = goldenDaysApplyFog(color, vertexDistance, FogRenderDistanceEnd, FogEnvironmentalStart, FogEnvironmentalEnd, FogColor);

    #ifdef OIT_ALPHA_ONLY
    executeAlphaOnlyPhase(gl_FragCoord.z, color.a);
    #else
    fragColor = calculateFinalColor(color);
    #endif
}
