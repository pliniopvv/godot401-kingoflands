shader_type spatial;

uniform vec2 size = vec2(512);
uniform float teste;

uniform sampler2D grama;
uniform sampler2D deserto;
uniform sampler2D rocha;

uniform sampler2D humidade;
uniform sampler2D temperatura;

varying float vertex_x;
varying float vertex_z;

void vertex() {
	vertex_x = VERTEX.x;
	vertex_z = VERTEX.z;
}

void fragment() {
	float hum = texture(humidade, vec2(vertex_x, vertex_z)/size).r;
	
//	float select_texture = step(0.5, hum);
	vec3 corGrama = texture(grama, UV).rgb;
	vec3 corDeserto = texture(deserto, UV).rgb;
	
	
	vec3 cor = texture(grama, UV).rgb;
	if (hum < 0.45) {
		cor = corDeserto;
	} else if ((0.45 <= hum) && (hum <= 0.55)) {
		cor = mix(corDeserto, corGrama, smoothstep(0.45,0.55,hum));
	} else if (hum > 0.55) {
		cor = corGrama;
	}

//	cor = texture(humidade, vec2(vertex_x, vertex_z)/size).rgb;
	ALBEDO = cor;
//	ALBEDO = vec3(teste,teste,teste);
}
