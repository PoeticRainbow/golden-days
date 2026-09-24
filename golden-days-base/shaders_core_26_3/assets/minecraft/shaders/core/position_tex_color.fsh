#version 330
#extension GL_ARB_separate_shader_objects : require

// GD
//#include <minecraft:globals.glsl>
// used in early loading, so we copy here as said below
layout(std140) uniform Globals {
    ivec3 CameraBlockPos;
    float GlintAlpha;
    vec3 CameraOffset;
    float GameTime;
    vec2 ScreenSize;
    int MenuBlurRadius;
    int UseRgss;
};
// end GD

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
const vec4 dirtCorner = vec4(46.0 / 255.0, 33.0 / 255.0, 23.0 / 255.0, 254.0 / 255.0);
const vec2 dirtSize = vec2(16.0 / 480.0, 16.0 / 270.0);
const int guiScale = 2; // same as in options
const float dirtRepeat = 32.0 * guiScale;
// end GD

void main() {
    // GD
    vec2 adjustedTexCoord = texCoord0;
    // detect panorama overlay texture
    // equal compares each component as a boolean vector and then all makes sure theyre all true
    if (all(equal(texture(Sampler0, vec2(0.0)), dirtCorner))) {
        vec2 screenCoord = texCoord0 * ScreenSize;
        adjustedTexCoord = vec2(mod(screenCoord.x, dirtRepeat) / dirtRepeat, mod(screenCoord.y, dirtRepeat) / dirtRepeat) * dirtSize;
    }
    // end GD

    vec4 color = texture(Sampler0, adjustedTexCoord) * vertexColor;
    if (color.a == 0.0) {
        discard;
    }
    fragColor = color * ColorModulator;
}
