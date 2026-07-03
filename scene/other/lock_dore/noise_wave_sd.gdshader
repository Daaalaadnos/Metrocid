shader_type spatial;
render_mode cull_disabled, unshaded, specular_disabled;

uniform vec3 bass_color : source_color;
uniform float bass_alpha : hint_range(0.0, 1.0) = 0.8;
uniform sampler2D texture1 : source_color;
uniform vec2 move_dir;
uniform float tex_speed; // Теперь учитывается

uniform float wave_amp;
uniform float wave_freq;

varying vec2 move_uv;

void vertex() {
	move_uv = (UV * wave_freq) + (TIME * tex_speed * move_dir);
	
	vec4 height_tex = textureLod(texture1, move_uv, 0.0);
	
	float height = (height_tex.r * 2.0) - 1.0;
	
	VERTEX.z += height * wave_amp;
}

void fragment() {
	vec4 final_tex = textureLod(texture1, move_uv, 0.0);
	
	ALBEDO = final_tex.rgb * bass_color.rgb; 
	ALPHA = final_tex.a * bass_alpha;
}