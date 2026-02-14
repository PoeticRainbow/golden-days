const int FOG_SHAPE_SPHERICAL = 0;
const int FOG_SHAPE_CYLINDRICAL = 1;

float beta_fog_value(float vertexDistance, float fogFactor, float fogEnd) {
    // todo fix water fog and nether fog
    float betaFogStart = fogEnd * 0.333f * pow(fogFactor, 3);
    float betaFogEnd = fogEnd * 1.1f * fogFactor;
    if (vertexDistance <= betaFogStart) {
        return 0.0;
    } else if (vertexDistance >= betaFogEnd) {
        return 1.0;
    }

    return (vertexDistance - betaFogStart) / (betaFogEnd - betaFogStart);
}

float linear_fog_value(float vertexDistance, float fogStart, float fogEnd) {
    return beta_fog_value(vertexDistance, fogStart, fogEnd);
}

float total_fog_value(float sphericalVertexDistance, float cylindricalVertexDistance, float environmentalStart, float environmentalEnd, float renderDistanceStart, float renderDistanceEnd) {
    return linear_fog_value(sphericalVertexDistance, min(environmentalEnd / renderDistanceEnd, 1.0), renderDistanceEnd);
}

vec4 _linearFog(vec4 fragColor, vec2 fragDistance, vec4 fogColor, vec2 environmentFog, vec2 renderFog) {
#ifdef USE_FOG
    float fogValue = total_fog_value(fragDistance.y, fragDistance.x, environmentFog.x, environmentFog.y, renderFog.x, renderFog.y);
    return vec4(mix(fragColor.rgb, fogColor.rgb, fogValue * fogColor.a), fragColor.a);
#else
    return fragColor;
#endif
}

vec2 getFragDistance(vec3 position) {
    return vec2(max(length(position.xz), abs(position.y)), length(position));
}