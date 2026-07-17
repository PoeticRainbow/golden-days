#version 330

#moj_import <minecraft:globals.glsl>

uniform sampler2D InSampler;

in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 InSize;
    vec2 OutSize;
};

layout(std140) uniform ScanLinesConfig {
    float Speed;
    float MinimumValue;
    float MaximumValue;
};

out vec4 fragColor;

void main() {
    vec4 diffuseColor = texture(InSampler, texCoord);

    diffuseColor.rgb *= clamp(sin((texCoord.y + GameTime * Speed) * InSize.y) + 1.0, MinimumValue, MaximumValue);

    fragColor = vec4(diffuseColor.rgb, 1.0);
}
