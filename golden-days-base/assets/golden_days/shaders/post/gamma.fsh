#version 330

uniform sampler2D InSampler;

in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
};

layout(std140) uniform GammaConfig {
    float Gamma;
};

out vec4 fragColor;

void main() {
    vec4 diffuseColor = texture(InSampler, texCoord);
    vec3 outColor = pow(diffuseColor.rgb, vec3(1.0 / Gamma));
    fragColor = vec4(outColor, 1.0);
}
