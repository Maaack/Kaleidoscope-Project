shader_type canvas_item;

uniform bool enabled = true;
uniform vec2 viewOffset;
uniform vec2 texOffset;
uniform float texRotationOffset;
uniform float viewRotationOffset;
uniform float texMultiplier = 4.0;
uniform float zoom = 1.0;
uniform bool vignette = true;

vec4 desat(vec3 color, float factor)
{
	vec3 lum = vec3(0.299, 0.587, 0.114);
	vec3 gray = vec3(dot(lum, color));
	return vec4(mix(color, gray, factor), 1.0);
}

vec2 refl(vec2 p,vec2 o,vec2 n)
{
	return 2.0*o+2.0*n*dot(p-o,n)-p;
}

vec2 rot(vec2 p, vec2 o, float a)
{
    float s = sin(a);
    float c = cos(a);
	mat2 m  = mat2(vec2(c, -s), vec2(s, c));
	return o +  m * (p - o);
}


void fragment()
{
	vec2 uv = UV;
	vec2 center = vec2(0.5);
	if (enabled){
	float l = sqrt(4.0/3.0);

	uv = rot(uv, vec2(0.5), texRotationOffset);
    uv = uv*texMultiplier;
	uv = uv + texOffset;
	float size = sqrt(0.75);
	
    uv.y = abs(fract((uv.y-1.0)*0.5)*2.0-1.0);
    uv.x = fract(uv.x/l/3.0)*l*3.0;
    if(uv.y < 2.0*uv.x/l) uv = refl(uv, vec2(0), vec2(0.5, size));
    if(uv.y > 1.0) uv = refl(uv, vec2(0.0, 1.0), vec2(1.0, 0.0));
    if(uv.y < -2.0*uv.x/l) uv = refl(uv, vec2(0), vec2(-0.5, size));
    if(uv.y < 2.0*uv.x/l) uv = refl(uv, vec2(0), vec2(0.5,size));
    if(uv.y > 1.0) uv = refl(uv, vec2(0.0, 1.0), vec2(1.0, 0.0));
    if(uv.y < -2.0*uv.x/l) uv = refl(uv, vec2(0), vec2(-0.5, size));
    //uv.x = -uv.x*iChannelResolution[0].y/iChannelResolution[0].x + 0.5;


	//uv = uv / 4.0;
	
    uv = rot(uv, vec2(0.5), viewRotationOffset);
	//uv = rot (uv, vec2(0.5), TIME);
	//uv = UV;
	uv += viewOffset;

	 uv = (uv - center) * zoom + center;
	
	clamp(uv, vec2(0.0), vec2(1.0));
	}
    vec4 c = texture(TEXTURE, uv);
	
	//c = vec4(uv, 0.0, 1.0);
    //c = floor(c*5.0)*0.25;
	if (vignette){
		float dist = distance (center, UV);
		vec4 fade = c;
		float center_rad = 0.25;
		if (dist >center_rad){
			fade = vec4(desat(fade.xyz, clamp(dist * 1.5, 0.0, 1.0)));
			fade = (fade - (dist - center_rad) * 2.0 ) ;

		}
		c = vec4(fade.xyz, 1.0);
	}
	

	COLOR = c;
    
}

