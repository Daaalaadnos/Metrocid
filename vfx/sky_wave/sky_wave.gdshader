shader_type spatial;

render_mode cull_disabled, unshaded;

uniform vec3 bass_color : source_color;
uniform float bass_alpha : hint_range(0.0, 1.0);
uniform sampler2D noise_texture1 : repeat_enable;
uniform sampler2D noise_texture2 : repeat_enable;
uniform float tex_scale1 = 1.0;
uniform float tex_scale2 = 0.7;



uniform sampler2D sub_text:repeat_enable;
uniform float sub_value;

uniform vec2 text_move_dir;
uniform vec2 second_text_move_dir;
uniform float wave_amp = 0.2;

// Переменные для передачи из vertex во fragment
varying vec2 v_moving_uv;
varying vec2 v_moving_uv2;
varying float v_final_height;

uniform float depth = 0.05;

void vertex() {

    v_moving_uv = (UV * tex_scale1) + (TIME * text_move_dir);
	v_moving_uv2 = (UV * tex_scale2) + (TIME * -text_move_dir);
    
    // 3. Читаем шум для смещения геометрии
    float noise1 = textureLod(noise_texture1, v_moving_uv, 0.0).r;
    float noise2 = textureLod(noise_texture2, v_moving_uv2, 0.0).r;
	
	v_final_height = textureLod(sub_text, UV ,0.0).r;
	

    // 4. Двигаем вершину
    //VERTEX.y += (noise1 - v_final_height * sub_value) * wave_amp;
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	vec3 view_dir = normalize(vec3(
	        dot(VIEW, TANGENT),
	        dot(VIEW, BINORMAL),
	        dot(VIEW, NORMAL)
	    ));
	
	vec2 shifted_move_uv = v_moving_uv2 + view_dir.xy * depth;
	
	vec4 noise1 = textureLod(noise_texture1,v_moving_uv,0.0);
	vec4 noise2 = textureLod(noise_texture2, shifted_move_uv,0.0);
	vec3 final_text = (noise1.rgb * noise2.rgb) * bass_color;
	ALBEDO = final_text;
	ALPHA = bass_alpha;
}
