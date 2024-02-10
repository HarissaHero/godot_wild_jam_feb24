shader_type canvas_item;

uniform vec3 color = vec3(1., 0.5, 0.5);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
  COLOR = vec4(COLOR.xyz * color, 1.);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
