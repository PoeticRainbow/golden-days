#version 150

// beta takes 64 blocks before the fog starts, so 4 chunks
// far render in beta is 12 chunks, so 0.33333 is the fog start

float beta_fog_value(float vertexDistance, float fogStart, float fogEnd) {
    float betaFogEnd = fogEnd * 1.1f;
    float betaFogStart = fogEnd * 0.333f;
    if (vertexDistance <= betaFogStart) {
        return 0.0;
    } else if (vertexDistance >= betaFogEnd) {
        return 1.0;
    }

    return (vertexDistance - betaFogStart) / (betaFogEnd - betaFogStart);
}