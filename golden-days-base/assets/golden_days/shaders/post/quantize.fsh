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

void main() {
    vec4 diffuseColor = texture(InSampler, texCoord);

    vec3 colorBands = floor(diffuseColor.rgb * (ColorResolution - 1.0) + 0.5) / (ColorResolution - 1.0);
    vec3 quantized = min(colorBands, 1.0);

    fragColor = vec4(quantized, 1.0);
}

