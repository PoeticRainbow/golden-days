#version 330
#extension GL_ARB_separate_shader_objects : require

#include <golden_days:hsv.glsl>

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

#ifdef VULKAN
layout(location = 0) out vec4 fragColor;
#else
out vec4 fragColor;
#endif

#define POINT_COUNT 7
const vec2 CURVE_POINTS[POINT_COUNT] = vec2[POINT_COUNT](vec2(0, 6), vec2(16, 17), vec2(32, 62), vec2(80, 239), vec2(96, 252), vec2(208, 255), vec2(255, 255));

void main() {
    vec4 color = texture(InSampler, texCoord);

    vec3 hsv = rgb2hsv(color.rgb);
    int value = int(hsv.z * 255);

    float output_value = float(value);
    for(int i = 0; i < (POINT_COUNT - 1); i++) {
        vec2 point0 = CURVE_POINTS[i];
        vec2 point1 = CURVE_POINTS[i + 1];
        if(float(value) <= point1.x) {
            output_value = point0.y + (float(value) - point0.x) * (point1.y - point0.y) / (point1.x - point0.x);
            break;
        }
    }

    fragColor = vec4(hsv2rgb(vec3(hsv.x, hsv.y, output_value / 255.0)), 1.0);
}
