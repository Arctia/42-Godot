shader_type canvas_item;

uniform float height = 1.3;
uniform float frequency = 4.0;
uniform float speed = 1.2;

void vertex() {
	VERTEX.y += height * cos((frequency * UV.x) + (speed * TIME)); 
}
