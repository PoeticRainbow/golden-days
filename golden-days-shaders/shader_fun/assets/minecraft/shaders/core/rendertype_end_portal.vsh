#version 150

#moj_import <minecraft:projection.glsl>

in vec3 Position;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec4 worldPos;
out float vertexDistance;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(vec3(Position.x, Position.y, Position.z), 1.0);
    vertexDistance = length(gl_Position);

    if (ProjMat[2][3] == 0.0) {
        worldPos = vec4(0.0);
    } else {
        worldPos = vec4(vec3(Position.x, Position.y * 0.4, Position.z), 1.0);
    }
}
