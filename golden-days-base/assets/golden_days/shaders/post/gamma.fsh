#version 330
#extension GL_ARB_separate_shader_objects : require

uniform sampler2D InSampler;

#ifdef VULKAN
layout(location = 0) in vec2 texCoord;
#else
in vec2 texCoord;
#endif

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
};

layout(std140) uniform GammaConfig {
    float Gamma;
};

#ifdef VULKAN
layout(location = 0) out vec4 fragColor;
#else
out vec4 fragColor;
#endif

void main() {
    vec4 diffuseColor = texture(InSampler, texCoord);
    vec3 outColor = pow(diffuseColor.rgb, vec3(1.0 / Gamma));
    fragColor = vec4(outColor, 1.0);
}
