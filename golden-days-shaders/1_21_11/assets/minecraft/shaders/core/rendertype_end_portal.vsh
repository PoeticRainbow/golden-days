#version 330

// made by fayer3
// https://github.com/fayer3/1.10-End-Portal
// MIT Licensed

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>

in vec3 Position;

out vec4 texProj0;
out float sphericalVertexDistance;
out float cylindricalVertexDistance;
out vec3 pos;
out vec4 posNear;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    texProj0 = projection_from_position(gl_Position);
    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
    
    pos = Position;
    // near position to subtract the view bobbing, credits to @thederdiscohund
    posNear = inverse(ProjMat * ModelViewMat) * vec4(gl_Position.xy, -gl_Position.w, gl_Position.w);
}
