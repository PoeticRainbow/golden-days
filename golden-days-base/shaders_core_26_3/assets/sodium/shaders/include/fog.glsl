// no longer possible
// #import <golden_days:general.glsl>
// -------------------
// |       FOG       |
// -------------------
float goldenDaysLinearFogFactor(float vertexDistance, float fogEnd) {
    float fogStart = fogEnd * 0.25; // todo: for overworld, 0 for nether/end
    if(vertexDistance <= fogStart) {
        return 0.0;
    } else if(vertexDistance >= fogEnd) {
        return 1.0;
    }
    return clamp((vertexDistance - fogStart) / (fogEnd - fogStart), 0.0, 1.0);
}

float goldenDaysNetherFogFactor(float vertexDistance, float fogEnd) {
    float fogStart = 0.0; // 0 for nether/end
    if(vertexDistance <= fogStart) {
        return 0.0;
    } else if(vertexDistance >= fogEnd) {
        return 1.0;
    }
    return clamp((vertexDistance - fogStart) / (fogEnd - fogStart), 0.0, 1.0);
}

float goldenDaysExpFogFactor(float vertexDistance, float density) {
    return 1.0 - clamp(exp(-density * vertexDistance), 0.0, 1.0);
}

vec4 goldenDaysApplyFog(vec4 color, float vertexDistance, float renderDistance, float environmentStart, float environmentEnd, vec4 fogColor) {
    if(fogColor.a <= 0.0)
        return color;

    float factor = 0.0;
    if(environmentEnd > 96.0) {
        // OVERWORLD / DEFAULT FOG
        factor = goldenDaysLinearFogFactor(vertexDistance, renderDistance);
    } else if(environmentEnd == 96.0 && environmentStart == 10) {
        // NETHER FOG
        factor = goldenDaysNetherFogFactor(vertexDistance, renderDistance);
    } else if(environmentEnd == 96.0 && environmentStart == 0) {
        // BOSS FOG IN THE END
        factor = goldenDaysLinearFogFactor(vertexDistance, renderDistance);
    } else {
        // THICK FOG, LIQUID FOG
        // lava fog color (0.6, 0.1, 0)
        bool inLava = fogColor.r >= 0.6 && fogColor.g <= 0.1 && fogColor.b == 0.0;
        float density = inLava ? 2.0 : 0.1; // inLava ? 2.0 : (inWater ? 0.1 : 1.0);
        factor = goldenDaysExpFogFactor(vertexDistance, density);
    }

    return vec4(mix(color.rgb, fogColor.rgb, factor), color.a);
}
// end import


const int FOG_SHAPE_SPHERICAL = 0;
const int FOG_SHAPE_CYLINDRICAL = 1;

float linear_fog_value(float vertexDistance, float fogStart, float fogEnd) {
    // redirect to GD goldenDaysLinearFogFactor
    return goldenDaysLinearFogFactor(vertexDistance, fogEnd);
}

float total_fog_value(float sphericalVertexDistance, float cylindricalVertexDistance, float environmentalStart, float environmantalEnd, float renderDistanceStart, float renderDistanceEnd) {
    // redirect to GD goldenDaysLinearFogFactor
    return goldenDaysLinearFogFactor(sphericalVertexDistance, min(environmantalEnd, renderDistanceEnd));
}

vec4 _linearFog(vec4 fragColor, vec2 fragDistance, vec4 fogColor, vec2 environmentFog, vec2 renderFog, float fadeFactor) {
#ifdef USE_FOG
    // redirect to GD
    return goldenDaysApplyFog(fragColor, fragDistance.x, renderFog.y, environmentFog.x, environmentFog.y, fogColor);
#else
    return fragColor;
#endif
}

vec2 getFragDistance(vec3 position) {
    // redirect to GD
    return vec2(length(position), length(position));
}