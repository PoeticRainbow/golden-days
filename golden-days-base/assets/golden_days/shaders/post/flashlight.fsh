#version 330
#extension GL_ARB_separate_shader_objects : require

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

layout(std140) uniform FlashlightConfig {
    float CircleRadius;
    float Multiplier;
};

#ifdef VULKAN
layout(location = 0) out vec4 fragColor;
#else
out vec4 fragColor;
#endif

void main() {
    vec4 diffuseColor = texture(InSampler, texCoord);

    // distance from the center of the screen adjusted for the aspect ratio
    vec2 corrected = vec2(((texCoord.x - 0.5) * (InSize.x / InSize.y)) + 0.5, texCoord.y);
    float distanceFromCenter = clamp(1.0 - distance(corrected, vec2(0.5, 0.5)) * CircleRadius, 0.0, 1.0);
    diffuseColor.rgb *= distanceFromCenter * Multiplier;

    fragColor = vec4(diffuseColor.rgb, 1.0);
}
