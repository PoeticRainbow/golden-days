#version 150

#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:matrix.glsl>
#moj_import <minecraft:globals.glsl>

uniform sampler2D Sampler0;
uniform sampler2D Sampler1;

in vec4 guiProjection;
in vec3 relativePos;
in vec3 worldPos;

const vec3[] COLORS = vec3[](
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

out vec4 fragColor;

void main() {
    bool isGui = ProjMat[2][3] == 0.0;
    vec3 color = vec3(0.0f);
    for (int i = 0; i < 16; i++) {
        // fake depth by exaggerating distance from camera
        vec2 uv = isGui ? guiProjection.xy : worldPos.xz + relativePos.xz * (16 - i);

        if (!isGui) {
            float scale = i == 0 ? 0.125f : i == 1 ? 0.5f : 0.0625f;
            uv *= scale * 8.0f;
        }

        // rotate
        mat2 rotate = mat2_rotate_z(radians((i * i * 4321.0f + i * 9.0f) * 2.0f));
        uv = rotate * uv;

        if (i == 0) {
            color += texture(Sampler0, uv * 0.5f).rgb * 0.1f;
        } else {
            uv.y += GameTime * 29.16f;
            color += texture(Sampler1, uv * (i == 1 ? 0.5f : 0.0625f)).rgb * COLORS[i];
        }
    }
    fragColor = vec4(color, 1.0f);
    return;
}
