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

layout(std140) uniform BlurConfig {
    float ValueThreshold;
    int Quality;
    float SpreadRadius;
};

float Iterations = pow(Quality * 2 + 1, 2.0);
float InvertedThreshold = 1.0 / (1.0 - ValueThreshold);

#ifdef VULKAN
layout(location = 0) out vec4 fragColor;
#else
out vec4 fragColor;
#endif

void main() {
    float pixelSize = SpreadRadius / ScreenSize.y;
    vec2 squarePixelSize = vec2(pixelSize * (ScreenSize.y / ScreenSize.x), pixelSize);

    vec4 accum = vec4(0.0);
    for(int y = -Quality; y < Quality; y++) {
        for(int x = -Quality; x < Quality; x++) {
            vec2 shiftedUV = texCoord + vec2(x, y) * squarePixelSize;

            vec4 sample = clamp(texture(InSampler, shiftedUV) - ValueThreshold, 0.0, 1.0);
            float distanceFromCenter = pow(clamp(Quality - length(vec2(x, y)), 0.0, 1.0), 2.0);
            accum += sample * InvertedThreshold * distanceFromCenter;
        }
    }

    fragColor = vec4(accum.rgb / Iterations, 1.0);
}
