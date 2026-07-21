#version 330
#extension GL_ARB_separate_shader_objects : require

uniform sampler2D InSampler;

#ifdef VULKAN
layout(location = 0) in vec2 texCoord;
#else
in vec2 texCoord;
#endif

layout(std140) uniform SamplerInfo {
    vec2 InSize;
    vec2 OutSize;
};

layout(std140) uniform ResolutionConfig {
    float Resolution;
};

#ifdef VULKAN
layout(location = 0) out vec4 fragColor;
#else
out vec4 fragColor;
#endif

void main() {
    vec2 scaled = InSize / (InSize.y / Resolution);
    vec2 uv = floor(texCoord * scaled) / scaled;
    fragColor = vec4(texture(InSampler, uv).rgb, 1.0);
}
