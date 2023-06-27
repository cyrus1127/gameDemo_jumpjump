shader_type spatial;

uniform vec2 amplitude = vec2(0.1,0.1);
uniform vec2 frequency = vec2(1.4,2.5);
uniform vec2 time_factor = vec2(2.0,3.0);

uniform sampler2D texturemap : hint_albedo;
uniform vec2 texture_scale = vec2(8.0, 4.0);

uniform sampler2D uv_offset_texture : hint_black;
uniform vec2 uv_offset_scale = vec2(0.2, .2);
uniform float uv_offset_time_scale = .05;
uniform float uv_offset_amplitude = .2;

float height(vec3 pos, float time){
	bool isSecPFromZ = true;
	float val = 0.0;
	val = amplitude.x * sin(pos.x * frequency.x + time * time_factor.x) +  amplitude.y * sin( (isSecPFromZ ? pos.z : pos.y)  * frequency.x  + time * time_factor.y);
	return val;
}

void vertex(){
//	VERTEX.y -= sin(VERTEX.x*0.5);
	VERTEX.y += height(VERTEX , TIME);
	
	float h1 = height( VERTEX + vec3(0.0,0.0,0.2), TIME);
	float h2 =  height( VERTEX + vec3(0.0,0.0,-0.2), TIME);
	float h3 = height( VERTEX + vec3(0.2,0.0,0.0), TIME);
	float h4 =  height( VERTEX + vec3(-0.2,0.0,0.0), TIME);
	TANGENT = normalize(vec3(0.0,h1 - h2,0.4));
	BINORMAL = normalize(vec3(0.4,h3 - h4,0.0));
	NORMAL = cross(TANGENT,BINORMAL);
}

void fragment(){
	vec2 base_uv_offset = UV * uv_offset_scale;
	base_uv_offset += TIME * uv_offset_time_scale;
	
	vec2 texture_based_offset = texture(uv_offset_texture, base_uv_offset).rg;
	texture_based_offset = texture_based_offset * 2.0 - 1.0;
	
	vec2 texture_uv = UV * texture_scale;
	texture_uv += uv_offset_amplitude * texture_based_offset;
	
//	ALBEDO = texture(texturemap , UV * texture_scale).rgb;
	ALBEDO = texture(texturemap , texture_uv).rgb;
	if (ALBEDO.r > 0.9 && ALBEDO.g > 0.9 && ALBEDO.b > 0.9 ){
		ALPHA = 0.9;
	}else{
		ALPHA = 0.5;
	}
	
	METALLIC = 0.5;
	ROUGHNESS = 0.1;
	
	// refraction
	float refraction = 0.2;
	vec3 ref_normal = normalize( mix(NORMAL, TANGENT * NORMALMAP.x + BINORMAL * NORMALMAP.y + NORMAL * NORMALMAP.z , NORMALMAP_DEPTH) );
	vec2 ref_ofs = SCREEN_UV - ref_normal.xy * refraction;
	EMISSION += textureLod( SCREEN_TEXTURE, ref_ofs, ROUGHNESS * 8.0 ).rgb * (1.0 - ALPHA); 
	ALBEDO *= ALPHA;
	ALPHA = 1.0;
	
}
