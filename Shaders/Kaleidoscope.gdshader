shader_type canvas_item;

uniform bool enabled = true;

uniform float border_radius = 0.25;
uniform float center_radius = 0.25;

uniform float segments = 4.0;
uniform bool use_polygon_radius = false;
uniform bool select_outside_slice = false;
uniform bool show_slice_only = false;

uniform bool show_debug = false;

const float PI = 3.14159265358979323846;
const float PI_TWO = 6.28318530718f;
const vec2 CENTER = vec2 (0.5, 0.5);

// can I define macros in godot shader language?
const float SEG_BORDER_ANGLE () {
	return (PI_TWO) / segments;
}

// can I define macros in godot shader language?
const float HALF_SEG_BORDER_ANGLE () {
	return (PI) / segments;
}


vec2 cartToPolarUV(vec2 coord, vec2 center){
	//shift to the center
	vec2 shiftCoord = coord - center;
	//pythagorias
	float uvRadius = sqrt(dot(shiftCoord, shiftCoord));
	// arc tan of coords gives angle
	float uvAngle = atan(shiftCoord.y, shiftCoord.x);

	return vec2(uvRadius, uvAngle);
}

vec2 polarToCartUV(float angle, float radius, vec2 center){
	//add 0.5 to shift center back
	return vec2(cos(angle), sin(angle) )* radius + center;
}

float angleIsInSegment(float angle){
	return round(angle / SEG_BORDER_ANGLE());
}

float doMod(float mod1, float mod2){
	return mod1 - mod2 * floor(mod1 / mod2);
}

bool insideCenterShape (vec2 center, vec2 uv){
	//sloooooowww but trippy
	bool c = false;
	int s = int(segments); 
	int j = s - 1;
	for (int i = 0; i < s; j = i++){
		//float fI =  float(i);
		vec2 pVtexI = polarToCartUV(float(i)*SEG_BORDER_ANGLE(), center_radius, CENTER);
		vec2 pVtexJ = polarToCartUV(float(j)*SEG_BORDER_ANGLE(), center_radius, CENTER);
		if (((pVtexI.y > uv.y) != (pVtexJ.y > uv.y))
					&& (uv.x < (pVtexJ.x - pVtexI.x) * (uv.y -pVtexI.y) / (pVtexJ.y - pVtexI.y) + pVtexI.x)){
				c = !c;
				
		}
	}
	return c;
}

bool insideCenterCircle (vec2 center, vec2 uv){
	return distance(center, uv) < center_radius;
}

bool inside(vec2 center, vec2 uv){
	bool ins;
	/*if (use_polygon_radius){
		ins = insideCenterShape(center, uv);
	} else {
		ins = insideCenterCircle(center, uv);
	}*/
	ins = use_polygon_radius? insideCenterShape(center, uv) : insideCenterCircle(center, uv);
	return select_outside_slice? !ins : ins;
}

vec2 getCenterUV(vec2 uv){
	vec2 center = CENTER;
	
	//get polar coordinates
	vec2 pRadAngle = cartToPolarUV(uv, center);
	//float uvRadius = pRadAngle.x;
	//float uvAngle = pRadAngle.y;
	
	if (!inside(center, uv)){
		float seg = angleIsInSegment(pRadAngle.y);
		
		float angleToCenter = seg * SEG_BORDER_ANGLE();
		
		float radiusToCenter = center_radius * 2.0;
		
		center = polarToCartUV(angleToCenter, radiusToCenter, center);
	}
	return center;
}

vec2 sliceUV(vec2 uv){
	vec2 center = getCenterUV(uv);
	vec2 pRadAngle = cartToPolarUV(uv, center);
	float uvRadius = pRadAngle.x;
	float uvAngle = pRadAngle.y;
				
	//where is the angle in segment space
	float angleInSegment = doMod(uvAngle, SEG_BORDER_ANGLE());//uvAngle - SEG_BORDER_ANGLE() * angleIsInSegment(uvAngle);

	//reflect across the segment.
	angleInSegment = min(angleInSegment, SEG_BORDER_ANGLE()  - angleInSegment);

	float segRadius = uvRadius / 2.0;
	float radiusInSegment =uvRadius; //doMod(uvRadius, center_radius);
	
	vec2 sliceUV = polarToCartUV(angleInSegment, radiusInSegment, CENTER);

	sliceUV = max(min(sliceUV, 2.0 - sliceUV), -sliceUV);

	return sliceUV;
}
// for Debugging
bool isSegBorderLine(vec2 uv){
	float pAngle = cartToPolarUV(uv, CENTER).y;
	float degUV = ((pAngle * ( 180.0 / PI )) / 360.0) + 0.5;
	float degSeg = ((SEG_BORDER_ANGLE() / 2.0 * ( 180.0 / PI )) / 360.0) ;
	return (degUV > degSeg - 0.001 && degUV < degSeg + 0.001);
}
bool inOriginalSlice(vec2 uv){
	
	if (!inside(CENTER, uv)) {
		return false;
	}
	//return true;
	float pAngle = cartToPolarUV(uv, CENTER).y;
	float degUV = ((pAngle * ( 180.0 / PI )) / 360.0) + 0.5;
	float degSeg = ((SEG_BORDER_ANGLE() / 2.0 * ( 180.0 / PI )) / 360.0) ;
	//COLOR = vec4(0,  degUV, 0, 1.0);
	
	return degUV < degSeg;
}



void fragment(){
	if (!enabled){
		COLOR = texture(TEXTURE, UV);

	} else {
	vec2 samp = sliceUV(UV);
	COLOR = texture(TEXTURE, samp);// vec4(UV,0, 1.0);
	
	if (show_debug){
		if (distance(getCenterUV(UV), UV) < 0.01){
			COLOR = vec4(1.0, 0, 0, 1.0);
		}
	}
	if (show_slice_only){
		if (!inOriginalSlice(UV)){
			discard;
		}
	}
	
	float dist = distance(CENTER,UV);
    if (dist > border_radius){
		COLOR = vec4(0.0,0.0,0.0,1.0);
		//discard;
	}
	}
	
	
}