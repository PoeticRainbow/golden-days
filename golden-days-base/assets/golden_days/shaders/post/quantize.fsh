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

layout(std140) uniform QuantizeConfig {
    vec3 ColorResolution;
};

#ifdef VULKAN
layout(location = 0) out vec4 fragColor;
#else
out vec4 fragColor;
#endif

void main() {
    vec4 diffuseColor = texture(InSampler, texCoord);

    vec3 colorBands = floor(diffuseColor.rgb * (ColorResolution - 1.0) + 0.5) / (ColorResolution - 1.0);
    vec3 quantized = min(colorBands, 1.0);

    fragColor = vec4(quantized, 1.0);
}

