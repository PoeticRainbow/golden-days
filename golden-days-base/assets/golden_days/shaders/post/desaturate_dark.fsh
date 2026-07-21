#version 330
#extension GL_ARB_separate_shader_objects : require

#include <golden_days:hsl.glsl>

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

#ifdef VULKAN
layout(location = 0) out vec4 fragColor;
#else
out vec4 fragColor;
#endif

void main() {
    vec4 diffuseColor = texture(InSampler, texCoord);

    vec3 hsl = RGBtoHSL(diffuseColor.rgb);
    hsl.y *= clamp(hsl.z * 2.0, 0.0, 1.0);

    vec3 rgb = HSLtoRGB(hsl);

    fragColor = vec4(rgb, 1.0);
}
