#version 330

uniform sampler2D InSampler;

in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 InSize;
    vec2 OutSize;
};

layout(std140) uniform FlashlightConfig {
    float CircleRadius;
    float Multiplier;
};

out vec4 fragColor;

void main() {
    vec4 diffuseColor = texture(InSampler, texCoord);

    // distance from the center of the screen adjusted for the aspect ratio
    vec2 corrected = vec2(((texCoord.x - 0.5) * (InSize.x / InSize.y)) + 0.5, texCoord.y);
    float distanceFromCenter = clamp(1.0 - distance(corrected, vec2(0.5, 0.5)) * CircleRadius, 0.0, 1.0);
    diffuseColor.rgb *= distanceFromCenter * Multiplier;

    fragColor = vec4(diffuseColor.rgb, 1.0);
}
