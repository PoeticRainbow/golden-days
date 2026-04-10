// Golden Days
// PoeticRainbow

const float EULER = 2.71828;

// -------------------
// |     TERRAIN     |
// -------------------
// used in 1.21.11+ to remove the smooth edges of pixels on the inside of faces, just like old
vec4 goldenDaysTexture(sampler2D source, vec2 uv, vec2 pixelSize) {
    return texture(source, (floor(uv * pixelSize) + 0.5) / pixelSize);
}

// -------------------
// |      LIGHT      |
// -------------------
float goldenDaysLight(float light_level, float ambient) {
    // level range [0, 1], ambient range [0, 1]
    float darkness = 1.0 - light_level;
    return (1.0 - darkness) / (darkness * 3.0 + 1.0) * (1.0 - ambient) + ambient;
}

// -------------------
// |       FOG       |
// -------------------
float goldenDaysLinearFogFactor(float vertexDistance, float fogEnd) {
    float fogStart = fogEnd * 0.25; // todo: for overworld, 0 for nether/end
    if (vertexDistance <= fogStart) {
        return 0.0;
    } else if (vertexDistance >= fogEnd) {
        return 1.0;
    }
    return clamp((vertexDistance - fogStart) / (fogEnd - fogStart), 0.0, 1.0);
}

float goldenDaysExpFogFactor(float vertexDistance, float density) {
    return 1.0 - clamp(pow(EULER, -density * vertexDistance), 0.0, 1.0);
}

vec4 goldenDaysApplyFog(vec4 color, float vertexDistance, float renderDistance, float environmentDistance, vec4 fogColor) {
    if (fogColor.a <= 0.0) return color;
    float factor = 0.0;
    // TODO: try and make nether use linear fog
    // <96 incorrectly triggers linear fog when underwater
    // >=96 incorrectly triggers exp fog in the nether
    if (environmentDistance > 96.0) {
        factor = goldenDaysLinearFogFactor(vertexDistance, renderDistance);
    } else {
        // thick fog
        // lava fog color (0.6, 0.1, 0)
        bool inLava = fogColor.r >= 0.6 && fogColor.g <= 0.1 && fogColor.b == 0.0;
        float density = inLava ? 2.0 : 0.1; // inLava ? 2.0 : (inWater ? 0.1 : 1.0);
        factor = goldenDaysExpFogFactor(vertexDistance, density);
    }
    return vec4(mix(color.rgb, fogColor.rgb, factor), color.a);
}

// -------------------
// |     SKY FOG     |
// -------------------
float goldenDaysLinearSkyFogFactor(float vertexDistance, float fogEnd) {
    if (fogEnd <= 64.0) return 1.0; // no sky renders on short or tiny in beta
    float fogStart = 0.0;
    fogEnd = fogEnd * 0.8;
    if (vertexDistance <= fogStart) {
        return 0.0;
    } else if (vertexDistance >= fogEnd) {
        return 1.0;
    }
    return clamp((vertexDistance - fogStart) / (fogEnd - fogStart), 0.0, 1.0);
}

vec4 goldenDaysApplySkyFog(vec4 color, float vertexDistance, float renderDistance, float environmentDistance, vec4 fogColor) {
    if (fogColor.a <= 0.0) return color;
    float factor = goldenDaysLinearSkyFogFactor(vertexDistance, min(renderDistance, environmentDistance));
    return vec4(mix(color.rgb, fogColor.rgb, factor), color.a);
}

// -------------------
// |      INFO       |
// -------------------
// all references are with Nostalgia mappings on b1.7.3
// fog mode = inLiquid ? GL_EXP : GL_LINEAR;
// GL_LINEAR f = (end - distance) / (end - start)
// GL_EXP f = e^(-density * distance)

// renderDistance = 256 >> [0, 1, 2, 3];
// far = 256 (16 chunks)
// normal = 128 (8 chunks)
// short = 64 (4 chunks)
// tiny = 32 (2 chunks)

// SKY on normal or far (literally no sky renders on short or tiny, GameRenderer @ line 498)
// fog start = 0.0
// fog end = renderDistance * 0.8
// TERRAIN (GameRenderer @ lines 936-950)
// fog start = renderDistance * (isOverworld ? 0.25 : 0.0)
// fog end = renderDistance

// fog density = inLava ? 2.0 : (inWater ? 0.1 : 1.0);
// from khronos docs https://registry.khronos.org/OpenGL-Refpages/gl2.1/xhtml/glFog.xml
// GL_FOG_DENSITY
//      params is a single integer or floating-point value that specifies density,
//      the fog density used in both exponential fog equations. Only nonnegative
//      densities are accepted. The initial fog density is 1. 