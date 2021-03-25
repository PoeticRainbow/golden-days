#version 150

const float MINECRAFT_LIGHT_POWER   = 0.6;
const float MINECRAFT_AMBIENT_LIGHT = 0.4;

vec4 minecraft_mix_light(vec3 lightDir0, vec3 lightDir1, vec3 normal, vec4 color) {
	lightDir0 = normalize(lightDir0);
	lightDir1 = normalize(lightDir1);
	float light0 = max(0.0, dot(lightDir0, normal));
	float light1 = max(0.0, dot(lightDir1, normal));
	float lightAccum = min(1.0, (light0 + light1) * MINECRAFT_LIGHT_POWER + MINECRAFT_AMBIENT_LIGHT);
	return vec4(color.rgb * lightAccum, color.a);
}

const float LIGHT_UV_MIN = 0.5  / 16.0;
const float LIGHT_UV_MAX = 15.5 / 16.0;
const vec3  LUMA_REC601 = vec3(0.299, 0.587, 0.114);

const float[] LIGHT_LUT = float[](
	0.04705882, 0.06274509, 0.08235294, 0.10196078,
	0.12549019, 0.15294117, 0.18431372, 0.21960784,
	0.25882352, 0.30588235, 0.36470588, 0.43529411,
	0.52156862, 0.63529411, 0.78823529, 1.0
);

const float[] BLOCKLIGHT_LUT = float[](
	0.06274509, 0.08235294, 0.10980392, 0.13333333,
	0.16470588, 0.2,        0.24313725, 0.28627450,
	0.33725490, 0.39215686, 0.46274509, 0.54117647,
	0.62745098, 0.72941176, 0.85098039, 1.0
);

const bool USE_INCREMENTAL_DAYLIGHT = false;


vec4 get_light_lut_value (vec4 bl, vec4 sl, ivec2 uv)
{
	float bl_g = dot(bl.rgb, LUMA_REC601) * LIGHT_LUT[uv.x >> 4];
	float sl_g = dot(sl.rgb, LUMA_REC601) * BLOCKLIGHT_LUT[uv.y >> 4];

	// if (USE_INCREMENTAL_DAYLIGHT)
	// {
	// 	sl_g = floor(sl_g * 8.) / 8.;
	// }

	return vec4(
		vec3(max(bl_g, sl_g)),
		max(bl.a, sl.a)
	);
}


vec4 minecraft_sample_lightmap (sampler2D lightMap, ivec2 uv)
{
	vec4 sl = texture(lightMap, vec2(LIGHT_UV_MIN, LIGHT_UV_MAX));
	vec4 bl = texture(lightMap, vec2(LIGHT_UV_MAX, LIGHT_UV_MIN));

	return get_light_lut_value(bl, sl, uv);
	//return texture(lightMap, clamp(uv / 256.0, vec2(0.5 / 16.0), vec2(15.5 / 16.0)));
}


vec4 minecraft_fetch_lightmap (sampler2D lightMap, ivec2 uv)
{
	vec4 sl = texelFetch(lightMap, ivec2(0, 15), 0);
	vec4 bl = texelFetch(lightMap, ivec2(15, 0), 0);

	return get_light_lut_value(bl, sl, uv);
}



