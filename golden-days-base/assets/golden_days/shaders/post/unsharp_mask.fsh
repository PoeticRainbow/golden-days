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

layout(std140) uniform UnsharpConfig {
    float Strength;
};

#ifdef VULKAN
layout(location = 0) out vec4 fragColor;
#else
out vec4 fragColor;
#endif

void main() {
    // 3x3 blur
    vec3 blurred = vec3(0.0);
    for(int j = -1; j <= 1; j++) {
        for(int i = -1; i <= 1; i++) {
            vec2 pixelOffset = vec2(float(i), float(j)) / InSize;
            blurred += texture(InSampler, texCoord + pixelOffset).rgb;
        }
    }
    blurred /= 9.0;

    vec3 color = texture(InSampler, texCoord).rgb;
    vec3 sharpened = color + Strength * (color - blurred);

    fragColor = vec4(clamp(sharpened, 0.0, 1.0), 1.0);
}
