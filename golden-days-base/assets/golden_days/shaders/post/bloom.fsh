#version 330
#extension GL_ARB_separate_shader_objects : require

uniform sampler2D MainSampler;
uniform sampler2D BloomSampler;

#ifdef VULKAN
layout(location = 0) in vec2 texCoord;
#else
in vec2 texCoord;
#endif

layout(std140) uniform SamplerInfo {
    vec2 InSize;
    vec2 OutSize;
};

layout(std140) uniform BloomConfig {
    float BloomStrength;
};

#ifdef VULKAN
layout(location = 0) out vec4 fragColor;
#else
out vec4 fragColor;
#endif

void main() {
    vec4 diffuseColor = texture(MainSampler, texCoord);

    vec4 bloom = texture(BloomSampler, texCoord);
    bloom = bloom * BloomStrength;

    diffuseColor.rgb += bloom.rgb;

    fragColor = vec4(diffuseColor.rgb, 1.0);
}
