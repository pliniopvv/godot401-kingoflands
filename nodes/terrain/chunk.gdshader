shader_type spatial;

uniform vec2 size = vec2(12);
uniform vec2 pos = vec2(0);
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
	vec2 relPos = (vec2(vertex_x, vertex_z)/size - (pos/size));
	float hum = texture(humidade, relPos).r;
	
	vec3 corGrama = texture(grama, UV).rgb;
	vec3 corDeserto = texture(deserto, UV).rgb;
	
	vec3 cor = texture(grama, UV).rgb;
	if (hum < 0.5) {
		cor = corDeserto;
	//} else if ((0.45 <= hum) && (hum <= 0.55)) {
		////cor = mix(corDeserto, corGrama, smoothstep(0.45,0.55,hum));
		//cor = vec3(1.0,0.0,0.0);
	//} else if (hum > 0.55) {
	} else if (hum >= 0.50) {
		cor = corGrama;
	}

	//cor = texture(humidade, vec2(vertex_x, vertex_z)/size).rgb;
	ALBEDO = cor;
	//ALBEDO = vec3(hum,hum,hum);
	//ALBEDO = vec3(teste,teste,teste);
}
