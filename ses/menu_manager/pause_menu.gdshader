shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float blur_amount : hint_range(0.0, 10.0) = 5.0;



void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 texel_size = vec2(blur_amount / float(TEXTURE_PIXEL_SIZE.x), blur_amount / float(TEXTURE_PIXEL_SIZE.y));
	vec4 color = vec4(0.0);
	for (int x = -1; x <= 1; x++) {
		for (int y = -1; y <= 1; y++) {
			color += texture(screen_texture, UV + texel_size * vec2(float(x), float(y)));
			}
			}
			color /= 9.0;
			COLOR = color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
