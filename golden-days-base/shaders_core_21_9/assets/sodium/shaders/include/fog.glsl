#import <golden_days:include/general.glsl>

const int FOG_SHAPE_SPHERICAL = 0;
const int FOG_SHAPE_CYLINDRICAL = 1;

float linear_fog_value(float vertexDistance, float fogStart, float fogEnd) {
    return goldenDaysLinearFogFactor(vertexDistance, fogEnd);
}

float total_fog_value(float sphericalVertexDistance, float cylindricalVertexDistance, float environmentalStart, float environmentalEnd, float renderDistanceStart, float renderDistanceEnd) {
    return goldenDaysLinearFogFactor(sphericalVertexDistance, min(environmentalEnd, renderDistanceEnd));
}

vec4 _linearFog(vec4 fragColor, vec2 fragDistance, vec4 fogColor, vec2 environmentFog, vec2 renderFog) {
#ifdef USE_FOG
    return goldenDaysApplyFog(fragColor, fragDistance.x, renderFog.y, environmentFog.y, fogColor);
#else
    return fragColor;
#endif
}

vec2 getFragDistance(vec3 position) {
    return vec2(length(position), length(position));
}