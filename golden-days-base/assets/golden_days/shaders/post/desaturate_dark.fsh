#version 330

#moj_import <golden_days:hsl.glsl>

uniform sampler2D InSampler;

in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 InSize;
    vec2 OutSize;
};

out vec4 fragColor;

void main() {
    vec4 diffuseColor = texture(InSampler, texCoord);

    vec3 hsl = RGBtoHSL(diffuseColor.rgb);
    hsl.y *= clamp(hsl.z * 2.0, 0.0, 1.0);

    vec3 rgb = HSLtoRGB(hsl);

    fragColor = vec4(rgb, 1.0);
}
