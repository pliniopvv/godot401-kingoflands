shader_type spatial;

uniform sampler2D textura;
varying float vertex_x;
varying float vertex_y;

void vertex() {
	vertex_x = VERTEX.x;
	vertex_y = VERTEX.y;
}

void fragment() {
	vec3 rgbTex = texture(textura, UV).rgb;
	vec3 cor = vec3(sin(vertex_x),sin(vertex_x),0.0);
	ALBEDO = cor;
}
