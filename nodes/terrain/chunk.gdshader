shader_type spatial;

uniform vec2 size = vec2(12.0);
uniform vec2 origin = vec2(0.0);
uniform float teste;

uniform sampler2D grama;
uniform sampler2D deserto;
uniform sampler2D rocha;

uniform sampler2D humidade;
uniform sampler2D temperatura;

varying float vertex_x;
varying float vertex_z;
varying vec2 position;

void vertex() {
	position = vec2(VERTEX.x, VERTEX.z);
}

void fragment() {
	vec2 pos_origin = origin/size;
	vec2 uvmask = position/size - pos_origin;
	//vec2 uvmask = position/size;
	float hum = texture(humidade, uvmask).r;
	float temp = texture(temperatura, uvmask).r;
	
	vec3 corGrama = texture(grama, UV).rgb;
	vec3 corDeserto = texture(deserto, UV).rgb;
	
	vec3 cor = corGrama;
	if ((hum < 0.35) && (temp > 0.45)) {
		cor = corDeserto;
	//} else if ((0.45 <= hum) && (hum <= 0.55)) {
		////cor = mix(corDeserto, corGrama, smoothstep(0.45,0.55,hum));
		//cor = vec3(1.0,0.0,0.0);
	//} else if (hum > 0.55) {
	}

	//cor = texture(humidade, vec2(vertex_x, vertex_z)/size).rgb;
	ALBEDO = cor;
	
	
	
	//
	//
	//		TESTAGEM DA HUMIDADE
	//
	//
	//

	//ALBEDO = vec3(hum,1.0-hum,0.0);
	//if (step(0.5,hum) == 0.0) {
		//ALBEDO = vec3(1.0,0.0,0.0);
	//} else {
		//ALBEDO = vec3(0.0,1.0,0.0);
	//}
	
	//ALBEDO = vec3(teste,teste,teste);
}
