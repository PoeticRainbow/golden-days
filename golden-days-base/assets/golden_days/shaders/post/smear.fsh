#version 330
#extension GL_ARB_separate_shader_objects : require

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
    vec4 currentColor = texture(InSampler, texCoord);
    vec4 previousColor = texture(PreviousSampler, texCoord);

    if(previousColor.a <= 0.0) {
        fragColor = vec4(currentColor.rgb, 1.0);
        return;
    }

    float noise = (random(texCoord) - 0.5) * 0.05;

    vec3 difference = abs(currentColor.rgb - previousColor.rgb) + vec3(noise);
    float red = difference.r > Threshold ? currentColor.r : previousColor.r;
    float green = difference.g > Threshold ? currentColor.g : previousColor.g;
    float blue = difference.b > Threshold ? currentColor.b : previousColor.b;

    fragColor = vec4(vec3(red, green, blue), 1.0);
}
