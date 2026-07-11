#version 330

uniform sampler2D InSampler;

in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 InSize;
    vec2 OutSize;
};

layout(std140) uniform BloomConfig {
    int Quality;
    float ValueThreshold;
    float Resolution;
    float SpreadRadius;
};

float PixelSize = SpreadRadius / Resolution;

out vec4 fragColor;

void main() {
    vec4 diffuseColor = texture(InSampler, texCoord);

    vec2 squarePixelSize = vec2(PixelSize * (InSize.y / InSize.x), PixelSize);
    float maxDistance = max(float(Quality), 1.0);

    vec4 accum = vec4(0.0);
    float totalWeight = 0.0;
    for(int y = -Quality; y <= Quality; y++) {
        for(int x = -Quality; x <= Quality; x++) {
            vec2 offset = vec2(x, y);
            vec2 shiftedUV = texCoord + offset * squarePixelSize;
            vec4 sample = texture(InSampler, shiftedUV);

            float distanceWeight = clamp(1.0 - length(offset) / maxDistance, 0.0, 1.0);
            float colorWeight = clamp(1.0 - length(sample.rgb - diffuseColor.rgb) / ValueThreshold, 0.0, 1.0);
            float weight = distanceWeight * colorWeight;

            accum += sample * weight;
            totalWeight += weight;
        }
    }

    if(totalWeight > 0.0) {
        accum /= totalWeight;
    }
    diffuseColor.rgb = mix(diffuseColor.rgb, accum.rgb, 0.5);

    fragColor = vec4(diffuseColor.rgb, 1.0);
}
