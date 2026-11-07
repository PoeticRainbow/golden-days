#version 330
#extension GL_ARB_separate_shader_objects : require

#include <golden_days:ycc.glsl>

uniform sampler2D LumaSampler;
uniform sampler2D ChromaSampler;

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

const float DARK_STEPS = 1.0 / 64.0;
const float LIGHT_STEPS = 1.0 / 128.0;

void main() {
    // full res
    vec4 lumaRgb = texture(LumaSampler, texCoord);
    // quarter res (half on both axis)
    vec4 chromaRgb = texture(ChromaSampler, texCoord);

    vec3 lumaYcc = rgb2ycc(lumaRgb.rgb);
    vec3 chromaYcc = rgb2ycc(chromaRgb.rgb);

    // quantize darker regions
    float step = lumaYcc.x < 0.01 ? DARK_STEPS : LIGHT_STEPS;
    lumaYcc.x = floor(lumaYcc.x / step + 0.5) * step;

    fragColor = vec4(ycc2rgb(vec3(lumaYcc.x, chromaYcc.y, chromaYcc.z)), 1.0);
}

