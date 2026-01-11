shader_type canvas_item;

uniform sampler2D noise_tex;
uniform float noise_scale : hint_range(0.0, 500) = 200.0;
uniform float noise_strength : hint_range(0.0, 0.2) = 0.05;


void fragment() {
	vec4 base_color = COLOR;

	vec2 uv = UV * noise_scale;
	float noise = texture(noise_tex, uv).r;
	
	noise = noise * 2.0 - 1.0;

	float n = (noise + 1.0) * 0.5; // [0,1]
	base_color.rgb *= 0.7 + n * 0.3; // slightly bright/dark per pixel	
	//COLOR = vec4(vec3(texture(noise_tex, UV * noise_scale).r), 1.0);

	COLOR = base_color;
}