#version 150

#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:globals.glsl>

in vec3 Position;

out vec4 guiProjection;
out vec3 relativePos;
out vec3 worldPos;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0f);

    guiProjection = projection_from_position(gl_Position);

    relativePos = Position;
    worldPos = Position + (CameraBlockPos - CameraOffset);
}
