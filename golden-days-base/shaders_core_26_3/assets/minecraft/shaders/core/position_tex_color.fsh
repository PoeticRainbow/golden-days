#version 330
#extension GL_ARB_separate_shader_objects : require

// Can't moj_import in things used during startup, when resource packs don't exist.
// This is a copy of dynamicimports.glsl
layout(std140) uniform DynamicTransforms {
    mat4 ModelViewMat;
    mat4 TextureMat;
    vec4 ColorModulator;
    vec3 ModelOffset;
};

uniform sampler2D Sampler0;

layout(location = 0) in vec2 texCoord0;
layout(location = 1) in vec4 vertexColor;

layout(location = 0) out vec4 fragColor;

// GD
#define GUI_SCALE 4.0
const vec2 overlaySize = vec2(480.0, 270.0);
const vec4 dirtCorner = vec4(46.0 / 255.0, 33.0 / 255.0, 23.0 / 255.0, 254.0 / 255.0);
// end GD

void main() {
    // GD
    vec2 adjustedTexCoord = texCoord0;
    // detect panorama overlay texture
    // equal compares each component as a boolean vector and then all makes sure theyre all true
    if (all(equal(texture(Sampler0, vec2(0.0)), dirtCorner))) {
        // because gl_FragCoord is inverted vertically, the dirt doesn't line up unless the vertical resolution is a multiple of 270
        // was using ScreenSized before but mods use this godforsaken pipeline too early because they hate me and me only specifically /s
        vec2 screenCoord = vec2(gl_FragCoord.x, -gl_FragCoord.y);
        adjustedTexCoord = fract((screenCoord / GUI_SCALE) / overlaySize);
    }
    // end GD

    vec4 color = texture(Sampler0, adjustedTexCoord) * vertexColor;
    if (color.a == 0.0) {
        discard;
    }
    fragColor = color * ColorModulator;
}
