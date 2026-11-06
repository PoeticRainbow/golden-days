#version 330
#extension GL_ARB_separate_shader_objects : require

uniform sampler2D InSampler;
uniform sampler2D OverlaySampler;

#ifdef VULKAN
layout(location = 0) in vec2 texCoord;
#else
in vec2 texCoord;
#endif

layout(std140) uniform SamplerInfo {
    vec2 InSize;
    vec2 OutSize;
};

layout(std140) uniform OverlayConfig {
    vec2 OverlaySize;
    vec2 OverlayPosition;
    int OverlayScale;
};

#ifdef VULKAN
layout(location = 0) out vec4 fragColor;
#else
out vec4 fragColor;
#endif

void main() {
    vec4 color = texture(InSampler, texCoord);
    vec2 correctedTexCoord = vec2(texCoord.x, 1.0 - texCoord.y);
    vec2 screenCoord = InSize * correctedTexCoord;

    vec4 overlay = vec4(0.0);
    vec2 scaledOverlaySize = OverlaySize * OverlayScale;
    if(all(greaterThan(screenCoord, OverlayPosition)) && all(lessThan(screenCoord, OverlayPosition + scaledOverlaySize))) {
        overlay = texture(OverlaySampler, (screenCoord - OverlayPosition) / scaledOverlaySize);
    }

    fragColor = vec4(mix(color.rgb, overlay.rgb, overlay.a), 1.0);
}
