#version 330

#moj_import <golden_days:hsl.glsl>
#moj_import <minecraft:globals.glsl>

uniform sampler2D InSampler;

in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 InSize;
    vec2 OutSize;
};

out vec4 fragColor;

void main() {
    vec4 diffuseColor = texture(InSampler, texCoord);

    vec3 rainbowColor = RGBtoHSL(diffuseColor.rgb);
    rainbowColor.r = sin(GameTime * 100.0);
    rainbowColor = HSLtoRGB(rainbowColor);

    float average = ((diffuseColor.r + diffuseColor.g + diffuseColor.b) / 3.0);
    fragColor = vec4(mix(diffuseColor.rgb, rainbowColor.rgb, average), 1.0);
}
