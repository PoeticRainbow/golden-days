#version 330

uniform sampler2D InSampler;

in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 InSize;
    vec2 OutSize;
};

layout(std140) uniform QuantizeConfig {
    vec3 ColorResolution;
};

out vec4 fragColor;

float bayerDither(ivec2 coord) {
    int x = coord.x & 3;
    int y = coord.y & 3;
    int index = y * 4 + x;
    int bayerPattern[16] = int[16](
        0, 8, 2, 10,
        12, 4, 14, 6,
        3, 11, 1, 9,
        15, 7, 13, 5
    );
    return (float(bayerPattern[index]) + 0.5) / 16.0;
}

void main() {
    vec4 diffuseColor = texture(InSampler, texCoord);

    float dither = bayerDither(ivec2(texCoord * InSize));
    vec3 colorBands = floor(diffuseColor.rgb * (ColorResolution - 1.0) + dither) / (ColorResolution - 1.0);
    vec3 quantized = min(colorBands, 1.0);

    fragColor = vec4(quantized, 1.0);
}

