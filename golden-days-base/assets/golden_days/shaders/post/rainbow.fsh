#version 330
#extension GL_ARB_separate_shader_objects : require

#include <golden_days:hsl.glsl>
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

#ifdef VULKAN
layout(location = 0) out vec4 fragColor;
#else
out vec4 fragColor;
#endif

void main() {
    vec4 diffuseColor = texture(InSampler, texCoord);

    vec3 rainbowColor = RGBtoHSL(diffuseColor.rgb);
    rainbowColor.r = sin(GameTime * 100.0);
    rainbowColor = HSLtoRGB(rainbowColor);

    float average = ((diffuseColor.r + diffuseColor.g + diffuseColor.b) / 3.0);
    fragColor = vec4(mix(diffuseColor.rgb, rainbowColor.rgb, average), 1.0);
}
