shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;
uniform float y_scale = 1.0;
uniform sampler2D distortion_noise: repeat_enable;
uniform float distortion_strength = 0.02;
uniform float distortion_speed = 0.05;
uniform sampler2D reflection_noise: repeat_enable;
uniform float reflection_speed = 0.01;

void fragment() {
	float distortion_value = texture(distortion_noise, 
		vec2(UV.x - TIME*distortion_speed, UV.y)).r;
	distortion_value -= 0.5;
	distortion_value *= distortion_strength;
	
	float tex_screen_ratio = SCREEN_PIXEL_SIZE.y / 
		(TEXTURE_PIXEL_SIZE.y / y_scale);
	vec2 reflection_uv = vec2(SCREEN_UV.x,
		SCREEN_UV.y - 2.0*UV.y*tex_screen_ratio) + distortion_value;
	vec4 reflection_color = texture(screen_texture, reflection_uv);
	
	vec4 tex_color = texture(TEXTURE, UV);
	vec4 out_color = vec4(0.0);
	out_color = mix(tex_color, reflection_color, 0.5);
	
	float reflection_noise_value = texture(reflection_noise,
		vec2(UV.x*0.1-TIME*reflection_speed, UV.y) + distortion_value).r;
	reflection_noise_value = smoothstep(0.8, 1.0, 
		reflection_noise_value);
	out_color = mix(out_color, vec4(1.0), reflection_noise_value);
	COLOR = out_color;
}