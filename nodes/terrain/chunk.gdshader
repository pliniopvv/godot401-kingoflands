shader_type spatial;

uniform vec2 size = vec2(12.0);
uniform vec2 origin = vec2(0.0);
uniform float teste;

uniform sampler2D oeste;
uniform sampler2D leste;
uniform sampler2D norte;
uniform sampler2D sul;

uniform sampler2D bioma;

varying float vertex_x;
varying float vertex_z;
varying vec2 position;

void vertex() {
	position = vec2(VERTEX.x, VERTEX.z);
	vertex_x = VERTEX.x;
	vertex_z = VERTEX.z;
}

void fragment() {
	vec2 center = size/2.0;
	vec2 uvposition = position/size - (origin-center)*size;
	uvposition = uvposition - center;
	vec3 cor = texture(bioma, uvposition).rgb;

	if (UV.x < 0.1) {
		vec3 cOeste = texture(oeste, UV).rgb;
		cor = mix(cOeste, cor, smoothstep(0.0,0.2, UV.x)+0.5);
	}
	
	if (UV.x > 0.9) {
		vec3 cLeste = texture(leste, UV).rgb;
		cor = mix(cor, cLeste, smoothstep(0.8, 1.0, UV.x)-0.5);
	}
	
	if (UV.y > 0.9) {
		vec3 cNorte = texture(norte, UV).rgb;
		cor = mix(cor, cNorte, smoothstep(0.8,1.0, UV.y)-0.5);
	}
	
	if(UV.y < 0.1) {
		vec3 cSul = texture(sul, UV).rgb;
		cor = mix(cSul, cor, smoothstep(0.0,0.2, UV.y)+0.5);
	}

	ALBEDO = cor;
	//ALBEDO = vec3(vertex_x,vertex_z, 0.0);
	//ALBEDO = vec3(UV, 0.0);
}
