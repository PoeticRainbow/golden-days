#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>

in vec3 Position;

out vec4 worldPos;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(vec3(Position.x, Position.y, Position.z), 1.0f);

    if (ProjMat[2][3] == 0.0f) {
        worldPos = vec4(0.0f, 0.0f, 0.0f, 1.0f);
    } else {
        worldPos = vec4(vec3(Position.x, Position.y * 0.4f, Position.z), 1.0f);
    }
}
