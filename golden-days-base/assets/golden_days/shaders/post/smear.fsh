#version 330
#extension GL_ARB_separate_shader_objects : require

#include <golden_days:ycc.glsl>
#include <golden_days:noise.glsl>

uniform sampler2D InSampler;
uniform sampler2D PreviousSampler;

#ifdef VULKAN
layout(location = 0) in vec2 texCoord;
#else
in vec2 texCoord;
#endif

layout(std140) uniform SamplerInfo {
    vec2 InSize;
    vec2 OutSize;
};

layout(std140) uniform SmearConfig {
    float Threshold;
};

#ifdef VULKAN
layout(location = 0) out vec4 fragColor;
#else
out vec4 fragColor;
#endif

void main() {
    vec4 currentRgb = texture(InSampler, texCoord);
    vec4 previousRgb = texture(PreviousSampler, texCoord);

    if(previousRgb.a <= 0.0) {
        fragColor = vec4(currentRgb.rgb, 1.0);
        return;
    }

    vec3 currentYcc = rgb2ycc(currentRgb.rgb);
    vec3 previousYcc = rgb2ycc(previousRgb.rgb);

    float noise = (random(texCoord) - 0.5) * 0.05;

    vec3 difference = abs(currentYcc.rgb - previousYcc.rgb) + vec3(noise);
    float luma = difference.x > Threshold ? currentYcc.x : previousYcc.x;
    float red_chroma = difference.y > Threshold ? currentYcc.y : previousYcc.y;
    float blue_chroma = difference.z > Threshold ? currentYcc.z : previousYcc.z;

    fragColor = vec4(ycc2rgb(vec3(luma, red_chroma, blue_chroma)), 1.0);
}
