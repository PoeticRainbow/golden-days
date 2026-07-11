#version 330

#moj_import <minecraft:globals.glsl>

uniform sampler2D InSampler;

in vec2 texCoord;

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

out vec4 fragColor;

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
