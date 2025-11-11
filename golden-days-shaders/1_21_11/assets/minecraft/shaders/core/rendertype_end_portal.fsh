#version 330

// made by fayer3
// https://github.com/fayer3/1.10-End-Portal
// MIT Licensed

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:matrix.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:globals.glsl>

#define ON_END_GATEWAY

uniform sampler2D Sampler0;
uniform sampler2D Sampler1;

in vec4 texProj0;
in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec3 pos;
in vec4 posNear;

// colors from java random with seed 31100 from minecraft source, multiplied with the layer depth
const vec3[16] COLORS = vec3[](
    vec3(0.0086616456508636f, 0.0385879765538608f, 0.0434578709742602f),
    vec3(0.0063173793256282f, 0.0509597804397344f, 0.0475390627980232f),
    vec3(0.0147393568356831f, 0.0542339658737182f, 0.0535070419311523f),
    vec3(0.0249449380806514f, 0.0588657255683626f, 0.0615201549870627f),
    vec3(0.0349468089067019f, 0.0633745945416964f, 0.0523325617496783f),
    vec3(0.0345372661948204f, 0.0470680440465609f, 0.0669749950369199f),
    vec3(0.0462640881538391f, 0.0610877134583213f, 0.0907527750188654f),
    vec3(0.0536191469430923f, 0.0847658240795135f, 0.0500852227210998f),
    vec3(0.0589734322494930f, 0.0728575580649905f, 0.1084392666816711f),
    vec3(0.0549682199954986f, 0.0619807235896587f, 0.1053161583840847f),
    vec3(0.0762950531073978f, 0.0790161013603210f, 0.0849037851606096f),
    vec3(0.0408366580804189f, 0.1419438113768895f, 0.1375453025102615f),
    vec3(0.1180594515800476f, 0.0857396411895752f, 0.1288173317909240f),
    vec3(0.0295506134629249f, 0.1970861613750457f, 0.2012314125895500f),
    vec3(0.1364496966203053f, 0.2600068430105845f, 0.2013775805632273f),
    vec3(0.0607160508632659f, 0.2361154675483703f, 0.4961182028055191f)
);

const mat4 SCALE_TRANSLATE = mat4(
    0.5, 0.0, 0.0, 0.25,
    0.0, 0.5, 0.0, 0.25,
    0.0, 0.0, 1.0, 0.0,
    0.0, 0.0, 0.0, 1.0
);

mat4 end_portal_layer(float layer) {
    mat4 translate = mat4(
        1.0, 0.0, 0.0, 17.0 / layer,
        0.0, 1.0, 0.0, (2.0 + layer / 1.5) * (GameTime * 1.5),
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 1.0
    );

    mat2 rotate = mat2_rotate_z(radians((layer * layer * 4321.0 + layer * 9.0) * 2.0));

    mat2 scale = mat2((4.5 - layer / 4.0) * 2.0);

    return mat4(scale * rotate) * translate * SCALE_TRANSLATE;
}

out vec4 fragColor;

vec3 endportal_vanilla() {
    vec3 color = textureProj(Sampler0, texProj0).rgb * COLORS[0];
    for (int i = 0; i < PORTAL_LAYERS; i++) {
        color += textureProj(Sampler1, texProj0 * end_portal_layer(float(i + 1))).rgb * COLORS[i];
    }
    return color;
}

vec3 endportal_1_10() {
    vec3 cam = posNear.xyz / posNear.w;
    vec3 dir = pos.xyz - cam;
    vec3 camPos = vec3(CameraBlockPos % 100000) - CameraOffset;

    #if defined ON_END_GATEWAY && PORTAL_LAYERS == 16
        vec3 normal = abs(normalize(cross(dFdx(dir), dFdy(dir))));
        if (all(greaterThan(normal.xx, normal.yz))) {
            dir = dir.zxy;
            camPos = camPos.zxy;
        } else if (all(greaterThan(normal.zz, normal.xy))) {
            dir = dir.xzy;
            camPos = camPos.xzy;
        }
    #endif
    vec3 worldPos = camPos + dir;
    
    // code based on minecraft source, with some alterations
    vec3 tex = vec3(0);
    for (int i = 0; i < 16; i++) {
        float yOffset = 16.0 - i;
        float scale = 0.0625;
        if (i == 0) {
            yOffset = 65.0F;
            scale = 0.125F;
        } else if (i == 1) {
            scale = 0.5F;
        }
        float rotation = (i * i * 4321.0 + i * 9.0) * 2.0;
        float Cos = cos(radians(rotation));
        float Sin = sin(radians(rotation));
        mat2 rot = mat2(Cos, Sin, -Sin, Cos);
        vec2 coord = worldPos.xz + dir.xz * yOffset / abs(dir.y);
        coord *= scale;
        coord = rot * coord + vec2(0, GameTime * 1.63f);
        if (i == 0) {
            tex = texture(Sampler0, coord).rgb * 0.1f;
        } else {
            tex += texture(Sampler1, coord).rgb * COLORS[i];
        }
    }
    return tex;
}

void main() {
    vec3 color;
    if (ModelViewMat[3].z < -10000) {
        // in the menu always do the 2d version
        color = endportal_vanilla();
    } else if (PORTAL_LAYERS == 16) {
        #ifdef ON_END_GATEWAY
            color = endportal_1_10();
        #else
            color = endportal_vanilla();
        #endif
    } else {
        color = endportal_1_10();
    }
    fragColor = apply_fog(vec4(color, 1.0), sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}
