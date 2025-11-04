#version 150

#moj_import <minecraft:fog.glsl>


in float vertexDistance;
in vec4 vertexColor;

out vec4 fragColor;

void main() {
    vec4 color = vertexColor;
    float fogValue = linear_fog_value(vertexDistance, 0.0f, 0.0f);
    color.rgb = mix(color.rgb, FogColor.rgb, fogValue);
    fragColor = color;
}
