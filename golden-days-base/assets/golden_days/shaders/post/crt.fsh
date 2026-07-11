#version 330

const float PI = 3.14159;

uniform sampler2D InSampler;

in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 InSize;
    vec2 OutSize;
};

layout(std140) uniform CrtConfig {
    vec2 Curvature;
};

out vec4 fragColor;

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
