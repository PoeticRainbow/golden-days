#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:matrix.glsl>
#moj_import <minecraft:globals.glsl>

uniform sampler2D Sampler0;
uniform sampler2D Sampler1;

in vec4 worldPos;

const vec3[] COLORS = vec3[](
    vec3(0.008661645650863649f, 0.038587976553860835f, 0.04345787097426022f),
    vec3(0.006317379325628281f, 0.05095978043973446f, 0.047539062798023224f),
    vec3(0.014739356835683186f, 0.05423396587371826f, 0.05350704193115234f),
    vec3(0.024944938080651416f, 0.05886572556836264f, 0.061520154987062724f),
    vec3(0.0349468089067019f, 0.0633745945416964f, 0.052332561749678395f),
    vec3(0.0345372661948204f, 0.047068044046560925f, 0.06697499503691991f),
    vec3(0.04626408815383911f, 0.06108771345832131f, 0.09075277501886542f),
    vec3(0.05361914694309235f, 0.08476582407951355f, 0.05008522272109986f),
    vec3(0.058973432249493064f, 0.07285755806499057f, 0.10843926668167114f),
    vec3(0.054968219995498654f, 0.06198072358965874f, 0.1053161583840847f),
    vec3(0.07629505310739788f, 0.07901610136032104f, 0.08490378516060965f),
    vec3(0.040836658080418906f, 0.14194381137688955f, 0.13754530251026154f),
    vec3(0.1180594515800476f, 0.08573964118957521f, 0.12881733179092408f),
    vec3(0.02955061346292496f, 0.19708616137504578f, 0.20123141258955002f),
    vec3(0.13644969662030537f, 0.2600068430105845f, 0.20137758056322733f),
    vec3(0.060716050863265994f, 0.23611546754837037f, 0.4961182028055191f)
);

out vec4 fragColor;

void main() {
    if (worldPos == vec4(0.0f)) {
        fragColor = vec4(vec3(0.0f), 1.0f);
        return;
    }
    vec4 portalUv = vec4(worldPos.x / worldPos.y, worldPos.z / worldPos.y, 1.0f, 1.0f);
    
    vec3 color = textureProj(Sampler0, vec4(portalUv.x * 4.0f, portalUv.y * 4.0f, portalUv.z * 4.0f, portalUv.w)).rgb * 0.16f;
    for (int i = 0; i < 16; i++) {
        mat2 rotate = mat2_rotate_z(radians((i * i * 4321.0f + i * 9.0f) * 2.0f));
        mat2 scale = mat2((16.0f - i * 0.7f) * 0.015f);
        
        vec4 layerPos = mat4(scale * rotate) * portalUv;
        layerPos.y += GameTime * 1.5f;
        color += textureProj(Sampler1, layerPos).rgb * COLORS[i];
    }
    fragColor = vec4(color, 1.0f);
}
