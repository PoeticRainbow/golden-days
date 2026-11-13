#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:fog.glsl>
#include <minecraft:dynamictransforms.glsl>

// start GD
#include <golden_days:options.glsl>
// end GD

layout(std140) uniform SkyOccluderInfo {
    float OcclusionStartAngle;
    float OcclusionEndAngle;
};

layout(location = 0) in vec3 viewDirection;

layout(location = 0) out vec4 fragColor;

// start GD
#define START_ANGLE -2.25
#define END_ANGLE -18.0

vec3 getVoidColor(vec3 color) {
    return color * vec3(0.2, 0.2, 0.6) + vec3(0.04, 0.04, 0.1);
}
// end GD

void main() {
    vec3 worldDirection = normalize(transpose(mat3(ModelViewMat)) * viewDirection);
    float fragmentAngle = degrees(asin(clamp(worldDirection.y, -1.0, 1.0)));
    
    // start GD
    #ifdef BLUE_VOID
    float alpha = fragmentAngle > START_ANGLE ? 0.0 : 1.0;
    // void <-- --> fog
    float blend = smoothstep(START_ANGLE, END_ANGLE, fragmentAngle);
    vec3 voidColor = mix(ColorModulator.rgb, getVoidColor(ColorModulator.rgb), blend);
    fragColor = vec4(voidColor, alpha);
    #else
    float alpha = smoothstep(OcclusionStartAngle, OcclusionEndAngle, fragmentAngle);
    fragColor = vec4(ColorModulator.rgb, alpha);
    #endif
    // end GD
}
