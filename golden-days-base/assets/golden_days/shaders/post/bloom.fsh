#version 330

uniform sampler2D MainSampler;
uniform sampler2D BloomSampler;

in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 InSize;
    vec2 OutSize;
};

layout(std140) uniform BloomConfig {
    float BloomStrength;
};

out vec4 fragColor;

void main() {
    vec4 diffuseColor = texture(MainSampler, texCoord);

    vec4 bloom = texture(BloomSampler, texCoord);
    bloom = bloom * BloomStrength;

    diffuseColor.rgb += bloom.rgb;

    fragColor = vec4(diffuseColor.rgb, 1.0);
}
