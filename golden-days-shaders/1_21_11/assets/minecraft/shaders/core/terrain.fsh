#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:chunksection.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;

out vec4 fragColor;

// proper nearest-neighbor sampling, fixes smooth edges of pixels on the inside of faces just like old
vec4 sampleNearest(sampler2D sampler, vec2 uv, vec2 pixelSize) {
	return texture(sampler, (floor(uv * TextureSize) + 0.5f) / TextureSize);
}

void main() {
    vec4 color = sampleNearest(Sampler0, texCoord0, vec2(0f)) * vertexColor;
#ifdef ALPHA_CUTOUT
    if (color.a < ALPHA_CUTOUT) {
        discard;
    }
#endif
    fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}
