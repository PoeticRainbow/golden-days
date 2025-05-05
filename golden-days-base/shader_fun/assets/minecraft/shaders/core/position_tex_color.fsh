#version 150

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform vec2 ScreenSize;
uniform mat4 ProjMat;

const float gui_scale = 16.0; // actual gui scale * 8

in vec2 texCoord0;
in vec4 vertexColor;

out vec4 fragColor;

void main() {
    if (texture(Sampler0, vec2(0.99)) == vec4(1.0, 0.0, 0.0, 1.0)) {
        float pixel_x = texCoord0.x * (ScreenSize.x / gui_scale);
        float pixel_y = texCoord0.y * (ScreenSize.y / gui_scale);
        float tex_x = mod(pixel_x, gui_scale) / 8.0;
        float tex_y = mod(pixel_y, gui_scale) / 8.0;
        fragColor = texture(Sampler0, vec2(mod(tex_x, 0.5), mod(tex_y, 0.5)));
        return;
    }

    vec4 color = texture(Sampler0, texCoord0) * vertexColor;
    if (color.a == 0.0) {
        discard;
    }
    fragColor = color * ColorModulator;
}
