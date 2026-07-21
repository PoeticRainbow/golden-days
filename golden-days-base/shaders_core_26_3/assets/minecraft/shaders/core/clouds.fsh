#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:fog.glsl>
#include <minecraft:oit.glsl>

// Already imported in fog.glsl
//#include <golden_days:general.glsl>

layout(location = 0) in float vertexDistance;
layout(location = 1) in vec4 vertexColor;

#ifndef OIT_ALPHA_ONLY
layout(location = 0) out vec4 fragColor;
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
