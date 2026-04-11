shader_type canvas_item;

void vertex() {
	float mask = 1.0 - UV.y;
	VERTEX.x += sin(TIME * 2.0) * mask * 2.5;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
