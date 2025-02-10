shader_type spatial;

uniform vec3 water_color : source_color;
uniform float time_scale : hint_range(0.0, 10.0, 0.25) = 1.0;
uniform sampler2D water_normal_noise;

void fragment() {

	vec2 _uv = UV;

	_uv.x += sin(TIME * time_scale + (_uv.x * _uv.y) * 25.0) * 0.01;
	_uv.y += cos(TIME * time_scale + (_uv.x - _uv.y) * 25.0) * 0.01;

	ALBEDO = water_color;
	NORMAL_MAP = texture(water_normal_noise, _uv).rgb;
	NORMAL *= 0.5;
	ROUGHNESS = 0.001
	;

}
