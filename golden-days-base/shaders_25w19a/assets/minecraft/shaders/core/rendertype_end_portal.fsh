#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:matrix.glsl>
#moj_import <minecraft:globals.glsl>

uniform sampler2D Sampler0;
uniform sampler2D Sampler1;

in vec4 worldPos;

const vec3[] COLORS = vec3[](
    vec3(0.008661645650863649, 0.038587976553860835, 0.04345787097426022),
    vec3(0.006317379325628281, 0.05095978043973446, 0.047539062798023224),
    vec3(0.014739356835683186, 0.05423396587371826, 0.05350704193115234),
    vec3(0.024944938080651416, 0.05886572556836264, 0.061520154987062724),
    vec3(0.0349468089067019, 0.0633745945416964, 0.052332561749678395),
    vec3(0.0345372661948204, 0.047068044046560925, 0.06697499503691991),
    vec3(0.04626408815383911, 0.06108771345832131, 0.09075277501886542),
    vec3(0.05361914694309235, 0.08476582407951355, 0.05008522272109986),
    vec3(0.058973432249493064, 0.07285755806499057, 0.10843926668167114),
    vec3(0.054968219995498654, 0.06198072358965874, 0.1053161583840847),
    vec3(0.07629505310739788, 0.07901610136032104, 0.08490378516060965),
    vec3(0.040836658080418906, 0.14194381137688955, 0.13754530251026154),
    vec3(0.1180594515800476, 0.08573964118957521, 0.12881733179092408),
    vec3(0.02955061346292496, 0.19708616137504578, 0.20123141258955002),
    vec3(0.13644969662030537, 0.2600068430105845, 0.20137758056322733),
    vec3(0.060716050863265994, 0.23611546754837037, 0.4961182028055191)
);

out vec4 fragColor;

void main() {
    if (worldPos == vec4(0.0)) {
        fragColor = vec4(vec3(0.0), 1.0);
        return;
    }
    vec4 portalUv = vec4(worldPos.x / worldPos.y, worldPos.z / worldPos.y, 1.0, 1.0);
    
    vec3 color = textureProj(Sampler0, vec4(portalUv.x * 4, portalUv.y * 4, portalUv.z * 4, portalUv.w)).rgb * 0.16;
    for (int i = 0; i < 16; i++) {
        mat2 rotate = mat2_rotate_z(radians((i * i * 4321.0 + i * 9.0) * 2.0));
        mat2 scale = mat2((16 - i * 0.7) * 0.015);
        
        vec4 layerPos = mat4(scale * rotate) * portalUv;
        layerPos.y += GameTime * 1.5;
        color += textureProj(Sampler1, layerPos).rgb * COLORS[i];
    }
    fragColor = vec4(color, 1.0);
}
