shader_type spatial;
render_mode cull_disabled;

uniform sampler2D noise;
varying float vertex_y;

void vertex() {
	float x = (cos(TIME)/10.0)*smoothstep(0.0,1.0, VERTEX.y) + VERTEX.x;
	float z = (cos(TIME)/10.0)*smoothstep(0.0,1.0, VERTEX.y) + VERTEX.z;
	VERTEX.x = x;
	VERTEX.z = z;
	vertex_y = VERTEX.y;
}

void fragment() {
	NORMAL.y = 1.0;
	//vec3 cor1 = vec3(0.034,0.452,0.01);
	vec3 cor1 = vec3(0.17,0.17,0.10);
	vec3 cor2 = vec3(0.17,0.17,0.10)*2.0;
	vec3 preto = vec3(0.0);
	float cNoise = texture(noise, UV).r;
	vec3 rgb = mix(cor1, cor2, cNoise);
	vec3 cor = mix(preto, rgb, smoothstep(0.0,0.1, vertex_y));
	ALBEDO = cor;
	if (!FRONT_FACING) {
		NORMAL = -NORMAL;
	}
}