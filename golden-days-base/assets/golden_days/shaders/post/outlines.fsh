#version 330
#extension GL_ARB_separate_shader_objects : require

uniform sampler2D InSampler;
uniform sampler2D DepthSampler;

#ifdef VULKAN
layout(location = 0) in vec2 texCoord;
#else
in vec2 texCoord;
#endif

layout(std140) uniform SamplerInfo {
    vec2 InSize;
    vec2 OutSize;
};

layout(std140) uniform OutlineConfig {
    float OutlineDarkness;
    float OutlineThickness;
};

#ifdef VULKAN
layout(location = 0) out vec4 fragColor;
#else
out vec4 fragColor;
#endif

#define BLUR_RADIUS 1
#define BLUR_AREA float((2 * BLUR_RADIUS + 1) * (2 * BLUR_RADIUS + 1))
#define OUTLINE_STRENGTH 16.0

void main() {
    // 3x3 blur
    float blurred = 0.0;
    for(int j = -BLUR_RADIUS; j <= BLUR_RADIUS; j++) {
        for(int i = -BLUR_RADIUS; i <= BLUR_RADIUS; i++) {
            vec2 pixelOffset = vec2(float(i), float(j)) * OutlineThickness / InSize;
            blurred += texture(DepthSampler, texCoord + pixelOffset).r;
        }
    }
    blurred /= BLUR_AREA;

    float depth = texture(DepthSampler, texCoord).r;
    float edges = abs(depth - blurred) / depth;
    float outlines = clamp(edges * OUTLINE_STRENGTH, 0.0, 1.0);

    vec4 color = texture(InSampler, texCoord);
    vec3 outlineColor = color.rgb * OutlineDarkness;
    fragColor = vec4(mix(color.rgb, outlineColor, outlines), 1.0);
}
