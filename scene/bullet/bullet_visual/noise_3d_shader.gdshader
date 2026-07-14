shader_type spatial;

render_mode unshaded;

uniform sampler3D noise_tex_3d: filter_nearest;

uniform float change_speed = 0.5;

void vertex() {
}

void fragment() {
	vec3 uv3d = vec3(UV, TIME * change_speed);
	
	vec4 noise_color = texture(noise_tex_3d,uv3d);

	ALBEDO = noise_color.rgb;
	ALPHA = noise_color.a;
	
}
