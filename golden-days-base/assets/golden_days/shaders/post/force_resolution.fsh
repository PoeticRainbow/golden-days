#version 330

uniform sampler2D InSampler;

in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 InSize;
    vec2 OutSize;
};

layout(std140) uniform ResolutionConfig {
    float Resolution;
};

out vec4 fragColor;

void main() {
    vec2 scaled = InSize / (InSize.y / Resolution);
    vec2 uv = floor(texCoord * scaled) / scaled;
    fragColor = vec4(texture(InSampler, uv).rgb, 1.0);
}
