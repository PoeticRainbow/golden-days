#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:globals.glsl>

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

layout(std140) uniform ScanLinesConfig {
    float Speed;
    float MinimumValue;
    float MaximumValue;
};

#ifdef VULKAN
layout(location = 0) out vec4 fragColor;
#else
out vec4 fragColor;
#endif

void main() {
    vec4 diffuseColor = texture(InSampler, texCoord);

    diffuseColor.rgb *= clamp(sin((texCoord.y + GameTime * Speed) * InSize.y) + 1.0, MinimumValue, MaximumValue);

    fragColor = vec4(diffuseColor.rgb, 1.0);
}
