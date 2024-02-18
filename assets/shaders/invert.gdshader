shader_type canvas_item;

uniform sampler2D screen : hint_screen_texture;

float grayscale(vec4 color) {
	return 0.3 * color.r + 0.59 * color.g + 0.11 * color.b;
}

void fragment() {
	vec4 screen_color = texture(screen, SCREEN_UV);
	vec4 texture_color = texture(TEXTURE, UV);
	float a = grayscale(screen_color);
	float b = grayscale(texture_color);
	COLOR.rgb = vec3(a * (1.0 - b) + (1.0 - a) * b);
}
