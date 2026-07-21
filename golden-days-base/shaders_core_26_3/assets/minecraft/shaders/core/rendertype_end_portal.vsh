#version 330
#extension GL_ARB_separate_shader_objects : require

// made by fayer3
// edited for Golden Days
// https://github.com/fayer3/1.10-End-Portal
// MIT Licensed

#include <minecraft:fog.glsl>
#include <minecraft:projection.glsl>
#include <minecraft:dynamictransforms.glsl>

layout(location = 0) in vec3 Position;

layout(location = 0) out vec4 texProj0;
layout(location = 1) out float sphericalVertexDistance;
layout(location = 2) out float cylindricalVertexDistance;
layout(location = 3) out vec3 pos;
layout(location = 4) out vec4 posNear;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    texProj0 = projection_from_position(gl_Position);
    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
    
    pos = Position;
    // near position to subtract the view bobbing, credits to @thederdiscohund
    posNear = inverse(ProjMat * ModelViewMat) * vec4(gl_Position.xy, -gl_Position.w, gl_Position.w);
}
