// Golden Days
// PoeticRainbow

// used in 1.21.11+ to remove the smooth edges of pixels on the inside of faces, just like old
vec4 goldenDaysTexture(sampler2D source, vec2 uv, vec2 pixelSize) {
    return texture(source, (floor(uv * pixelSize) + 0.5) / pixelSize);
}

float goldenDaysLight(float light_level, float ambient) {
    // level range [0, 1], ambient range [0, 1]
    float darkness = 1.0 - light_level;
    return (1.0 - darkness) / (darkness * 3.0 + 1.0) * (1.0 - ambient) + ambient;
}