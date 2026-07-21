#version 330
#extension GL_ARB_separate_shader_objects : require

const float PI = 3.14159;

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

layout(std140) uniform CrtConfig {
    vec2 Curvature;
};

#ifdef VULKAN
layout(location = 0) out vec4 fragColor;
#else
out vec4 fragColor;
#endif

vec2 curveRemapUV(vec2 uv) {
    // as we near the edge of our screen apply greater distortion using a cubic function    uv = uv * 2.0–1.0;
    vec2 offset = abs(uv.yx) / vec2(Curvature.x, Curvature.y);
    uv = uv + uv * offset * offset;
    uv = uv * 0.5 + 0.5;
    return uv;
}

void main() {
    vec2 remappedUV = curveRemapUV(texCoord * 2.0 - 1.0);
    vec4 diffuseColor;
    if(remappedUV.x < 0.0 || remappedUV.x > 1.0 || remappedUV.y < 0.0 || remappedUV.y > 1.0) {
        // outside screen
        diffuseColor = vec4(vec3(0.0), 1.0);
    } else {
        diffuseColor = texture(InSampler, remappedUV);
    }
    fragColor = vec4(diffuseColor.rgb, 1.0);
}
