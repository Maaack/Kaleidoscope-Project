shader_type canvas_item;

uniform bool enabled = true;

uniform bool triangles = false;

uniform vec2 polarOutOffset = vec2(0);
uniform vec2 polarInOffset = vec2(0);
uniform float polarInRotationOffset = 0.5;


uniform vec2 triOutOffset = vec2(0);
uniform vec2 triInOffset = vec2(0);
uniform float triInRotationOffset = 0.5;

uniform float viewRotationOffset = -0.5;


uniform float texMultiplier = 1.0;
uniform float zoom = 1.0;

uniform float border_radius = 0.25;
uniform float center_radius = 0.25;
uniform float vignette_radius = 0;
uniform float normality_radius = 0;

uniform float segments = 6;
const float segmentOrigin = 1.57079632679489661923;
uniform bool reflect_in_segment = false;
uniform bool use_polygon_radius = false;
uniform bool reflect_outside = true;
uniform bool select_outside_slice = false;
uniform bool show_slice_only = false;

uniform float rotation_speed = 0.;


uniform vec3 color_enabled = vec3 (1.0, 1.0, 1.0);

uniform bool show_debug = false;

const float slice_selection = 0.0;

const float PI = 3.14159265358979323846;
const float PI_TWO = 6.28318530718f;
const vec2 CENTER = vec2 (0.5, 0.5);

// can I define macros in godot shader language?
const float SEG_BORDER_ANGLE () {
	return ((PI_TWO / segments) )  ;
}

const float FLOOR_SEG_BORDER_ANGLE(){
	return ((PI_TWO / floor(segments)));
}

// can I define macros in godot shader language?
const float HALF_SEG_BORDER_ANGLE () {
	return (PI) / segments;
}

const float ORIGIN(){
	return segmentOrigin - HALF_SEG_BORDER_ANGLE();
}
const float SEAM(){
	return PI + HALF_SEG_BORDER_ANGLE();
}
//UTIL///////////////////

vec2 cartToPolarUV(vec2 coord, vec2 center){
	//shift to the center
	vec2 shiftCoord = coord - center;
	//pythagorias
	float uvRadius = sqrt(dot(shiftCoord, shiftCoord));
	// arc tan of coords gives angle
	float uvAngle = atan(shiftCoord.y, shiftCoord.x);
	uvAngle =  -(uvAngle + ORIGIN());
	if (uvAngle < 0.0){
		uvAngle = (PI - abs(uvAngle)) + PI;
	}

	return vec2(uvRadius, uvAngle);
}

vec2 polarToCartUV(float angle, float radius, vec2 center){
	angle = -(ORIGIN() + angle);
	return vec2(cos(angle), sin(angle) )* radius + center;
}

bool insideCenterShape(vec2 uv){
  float d = 0.0;

  // Remap the space to -1. to 1.
  vec2 st = uv *2.-1.;
	float cr = center_radius *2.; // - 1.;

  // Number of sides of your shape
  int N = int(segments);

  // Angle and radius from the current pixel
  float a = atan(st.x,st.y)+PI;
  float r = PI_TWO/float(N);

  // Shaping function that modulate the distance
  	d = cos(floor(.5+a/r)*r-a)*length(st);

	return step(cr, d) == 0.0;

}

float centerShapeBorder (vec2 uv){
	float d = 0.0;

  // Remap the space to -1. to 1.
  vec2 st = uv *2.-1.;
	float cr = center_radius *2.; // - 1.;

  // Number of sides of your shape
  int N = int(segments);

  // Angle and radius from the current pixel
  float a = atan(st.x,st.y)+PI;
  float r = PI_TWO/float(N);
	vec2 cst = vec2(cos(a), sin(a) )* center_radius;
  	d = cos(floor(.5+a/r)*r-a)*length(cst);
	return d;
}


bool insideCenterCircle (vec2 center, vec2 uv){
	return distance(center, uv) < center_radius;
}

bool inside(vec2 center, vec2 uv){
	bool ins;
	ins = use_polygon_radius? insideCenterShape( uv) : insideCenterCircle(center, uv);
	return select_outside_slice? !ins : ins;
}

float displaceAngle (float uvAngle){
	
	float angle = uvAngle;
	//angle =
	float f = (SEG_BORDER_ANGLE() * floor(segments));// + (SEG_BORDER_ANGLE() );
	float extra =  (PI_TWO - f); //FLOOR_SEG_BORDER_ANGLE() - SEG_BORDER_ANGLE();//PI_TWO - (SEG_BORDER_ANGLE() * segments);

	if (extra == 0.0){
		return angle;
	}
	if (int(floor(segments)) %2 == 0){
		float seam = SEAM();//0.0+HALF_SEG_BORDER_ANGLE();
		
		if (angle > seam){
			angle = angle - extra;
		}
	} else {

		float seam_min = SEAM() - extra / 2.0  ;// extra / 2.0 ;
		float seam_max = SEAM() + extra / 2.0; //extra / 2.0;
		if ((angle < seam_max) && (angle > seam_min)){
			angle = SEG_BORDER_ANGLE() * segments + angle - seam_max;
		}
		else if (angle > seam_max){
			angle = angle - extra;
		}
	
	}
	return angle;
}

float angleIsInSegment(float angle){
	
	angle = displaceAngle(angle);

	float seg = floor((angle) / SEG_BORDER_ANGLE()  );
	
	return seg ;
}

float doMod(float mod1, float mod2){
	return mod1 - mod2 * floor(mod1 / mod2);
}

vec2 getCenterUV(vec2 uv){
	vec2 center = CENTER;
	
	//get polar coordinates
	vec2 pRadAngle = cartToPolarUV(uv, center);
	//float uvRadius = pRadAngle.x;
	//float uvAngle = pRadAngle.y;
	
	if (!inside(center, uv)){
		float seg = angleIsInSegment(pRadAngle.y);
		
		float angleToCenter = seg * SEG_BORDER_ANGLE();//VISBLE_SLICE_BORDER_ANGLE();
		
		float radiusToCenter = 0.5 - center_radius; // * 2.0;
		
		//center = polarToCartUV(angleToCenter, radiusToCenter, center);
	}
	return center;
}



////DEBUG FUNCS //////////////////

// for Debugging

bool isOriginBorderLine(vec2 uv){
	float pAngle = (cartToPolarUV(uv, CENTER).y);
	if (pAngle > (0.0 - 0.01) && pAngle < (0.0 + 0.01)){
		return true;
	}
	
	return false;
}

bool isSeamBorderLine(vec2 uv){
	float pAngle = (cartToPolarUV(uv, CENTER).y);
	if (pAngle > (HALF_SEG_BORDER_ANGLE() + PI - 0.01) && pAngle < (HALF_SEG_BORDER_ANGLE() + PI + 0.01)){
		return true;
	}
	
	return false;
}

bool isSegBorderLine(vec2 uv){
	float pAngle = (cartToPolarUV(uv, CENTER).y);
	float opSeg = SEG_BORDER_ANGLE();
	float pSeg = opSeg;// - HALF_SEG_BORDER_ANGLE();
	
	/*if  (pAngle > (opSeg - 0.01) && pAngle < (opSeg + 0.01)){
		return true;
	}
	return false;*/
	
	/*float degUV = ((pAngle * ( 180.0 / PI )) / 360.0) + 0.5;
	float degSeg = ((SEG_BORDER_ANGLE() / 2.0 * ( 180.0 / PI )) / 360.0) ;
	return (degUV > degSeg - 0.001 && degUV < degSeg + 0.001);*/
	while (pSeg == 0.0 || (pSeg <= PI_TWO)){
		
		if (pAngle > (pSeg - 0.01) && pAngle < (pSeg + 0.01)){
			return true;
		}
		if (pAngle < 0.01){
			return true;
		}
		pSeg = pSeg + opSeg;
	}
	return false;
}
bool inOriginalSlice(vec2 uv){
	
	if (!inside(CENTER, uv)) {
		return false;
	}
	//return true;
	float pAngle = cartToPolarUV(uv, CENTER).y;
	/*float degUV = ((pAngle * ( 180.0 / PI )) / 360.0) + 0.5;
	float degSeg = ((VISBLE_SLICE_BORDER_ANGLE() / 2.0 * ( 180.0 / PI )) / 360.0) ;
	//COLOR = vec4(0,  degUV, 0, 1.0);
	
	return degUV < degSeg;*/
	
	return pAngle <SEG_BORDER_ANGLE() ;
}

vec3 rainbow(float level)
{
	float maxSeg = float(segments);
	float r = float(level <= 2.0) + float(level > 4.0) * 0.5;
	float g = max(1.0 - abs(level - 2.0) * 0.5, 0.0);
	float b = (1.0 - (level - 4.0) * 0.5) * float(level >= 4.0);
	return vec3(r, g, b);
}



vec2 polyCartToPolarUV(vec2 st){
	  st = st *2.-1.;
	float a = atan(st.x,st.y)+PI;
  float r = sqrt(st.x * st.x + st.y * st.y);//PI_TWO/float(segments);

	return vec2 (r, a);
}

vec4 debugUV(vec2 uv, vec4 color){

	//vec4 color;
	vec2 pRadiusAngle = cartToPolarUV(uv, CENTER);
	//color = vec4 (pRadiusAngle.y / PI_TWO, 0.0, 0.0, 0.0);
	vec4 rainbowCol = vec4 (rainbow(angleIsInSegment(pRadiusAngle.y)), 1.0);
	//color = vec4(pRadiusAngle.x / PI_TWO, 0.0,  0.0, 1.0);
	/*COLOR = vec4(
		//rainbow(angleIsInSegment(pRadiusAngle.y), 1.0), 
		0.0, pRadiusAngle.y, 0.0, 1.0
	);*/
	if (inside(CENTER, uv)){
		//COLOR = COLOR + 0.1;
	}
		
	float radThresh = distance(CENTER, uv) - center_radius;
	if (radThresh < 0.001 && radThresh > -0.001){
		color = rainbowCol; //vec4(0, 1.0, 1.0, 1.0);
	}
		
	if (distance(getCenterUV(uv), uv) < 0.01){
		color = rainbowCol;//vec4(0, 1.0, 1.0, 1.0);
	}
		
	if (isSegBorderLine(uv)){
		color = rainbowCol; //vec4(0, 1.0, 1.0, 1.0);
	}
	if (isOriginBorderLine(uv)){
		return vec4(0, 1.0, 1.0, 1.0);
	}
	
	if (isSeamBorderLine(uv)){
		return vec4(0, 1.0, 1.0, 1.0);
	}
	
	return mix(color, rainbowCol, 0.5);//rainbowCol;
	return color;
}

/////////////////////////
//EFFECTS////////////////
vec4 desat(vec3 color, float factor)
{
	vec3 lum = vec3(0.299, 0.587, 0.114);
	vec3 gray = vec3(dot(lum, color));
	return vec4(mix(color, gray, factor), 1.0);
}

vec3 color_channel(vec3 color){
	if (color_enabled.r >= 1.0 && color_enabled.g >= 1.0 && color_enabled.b >= 1.0){
		return color;
	}
	
	float norm = 3.0 + (color_enabled.r + color_enabled.g + color_enabled.b);
	vec3 ds =  vec3(color.r + color.g + color.b) / norm;

//desat (color,1.0).xyz;
	//vec3 dds = (ds + color * color_enabled) - ds;
	vec3 dds = mix(ds, max(color, ds), color_enabled);
	 


	return dds;
}

vec2 rot(vec2 p, vec2 o, float a)
{
    float s = sin(a);
    float c = cos(a);
	mat2 m  = mat2(vec2(c, -s), vec2(s, c));
	return o +  m * (p - o);
}



vec4 vignette (vec2 uv, vec4 c){
	float dist = distance (CENTER, uv);
	vec4 fade = c;

	if (dist >center_radius){
		fade = desat (c.xyz, smoothstep (0, vignette_radius + center_radius, dist - center_radius));//vec4(desat(fade.xyz, clamp(dist * 2.0, 0.0, 1.0)));
		fade = fade - smoothstep(center_radius, border_radius,dist); //(fade - (dist - center_radius) * 0.5) ;
	}
	c = vec4(fade.xyz, 1.0);
	return c;
}

//TRIANGLES///////
vec2 refl(vec2 p,vec2 o,vec2 n)
{
	return 2.0*o+2.0*n*dot(p-o,n)-p;
}

vec2 triangleUV (vec2 uv, vec2 frag_coord) {
	float tri_sides =3.0;
	float l = sqrt(4.0/tri_sides);
	float size = sqrt(.75);

    uv.y = abs(fract((uv.y-1.0)*0.5)*2.0-1.0);
    uv.x = fract(uv.x/l/tri_sides)*l*tri_sides;
    if(uv.y < 2.0*uv.x/l) uv = refl(uv, vec2(0), vec2(0.5, size));
    if(uv.y > 1.0) uv = refl(uv, vec2(0.0, 1.0), vec2(1.0, 0.0));
    if(uv.y < -2.0*uv.x/l) uv = refl(uv, vec2(0), vec2(-0.5, size));
    if(uv.y < 2.0*uv.x/l) uv = refl(uv, vec2(0), vec2(0.5,size));
    if(uv.y > 1.0) uv = refl(uv, vec2(0.0, 1.0), vec2(1.0, 0.0));
    if(uv.y < -2.0*uv.x/l) uv = refl(uv, vec2(0), vec2(-0.5, size));
	uv.x = -uv.x * frag_coord.y / frag_coord.x + 0.5;
    //uv.x = -uv.x*iChannelResolution[0].y/iChannelResolution[0].x + 0.5;
	return uv;
}

///////////////////
//POLAR////////////

float radiusUV(float radius, bool isInside){

	if (!reflect_outside || isInside){
		return radius; // center_radius;
	} else {
		return  (center_radius * 2.0) - (radius ) ;
	}

}

float flipSegmentAngle(float angle){
	return SEG_BORDER_ANGLE() - angle;
}
float flip(float angleInSegment, float seg){
	//Flipping Logic
	bool odd_segments = int(floor(segments)) % 2 != 0;
	float mid = floor(segments) / 2.0;
	bool extra_segment = seg == floor(segments);
	bool mid_segment_is_even = int(floor(mid)) % 2 == 0;
	bool segment_is_even = int(seg + 1.0) % 2 == 0;
	bool rev_seg_is_even = int(segments - seg + 1.0) % 2 == 0;

	if ( (seg <= mid && segment_is_even) ||
		(seg > mid && !extra_segment && rev_seg_is_even) ||
		(extra_segment && odd_segments && mid_segment_is_even)) {
			
		angleInSegment = flipSegmentAngle(angleInSegment);
	}
		
	return angleInSegment;
}

vec2 sliceUV(vec2 uv){
	vec2 center = getCenterUV(uv);
	vec2 pRadAngle = cartToPolarUV(uv, center);
	float uvRadius = pRadAngle.x;
	float uvAngle = pRadAngle.y;
	
	float seg = angleIsInSegment(uvAngle);
	
	float angleInSegment = uvAngle;
	if (seg > 0.0 ){
		//Find Angle
		angleInSegment = displaceAngle(angleInSegment);// doMod(uvAngle , SEG_BORDER_ANGLE());
		if (seg < segments){
			angleInSegment = doMod(angleInSegment, SEG_BORDER_ANGLE());
		}
		
		angleInSegment = flip(angleInSegment, seg);
	}
	
	//reflect across the segment.
	if (reflect_in_segment ){
		angleInSegment = max(angleInSegment, SEG_BORDER_ANGLE()  - angleInSegment);
	}
	

	bool centerRing = inside(CENTER, uv);
	float radiusInSegment =radiusUV(uvRadius, centerRing); //doMod(uvRadius, center_radius);
	
	vec2 sliceUV = polarToCartUV(angleInSegment, radiusInSegment, CENTER);

	//sliceUV = max(min(sliceUV, 2.0 - sliceUV), -sliceUV);
	
	/*if (slice_selection > segments / 2.0){
		sliceUV.y = 1.0 - sliceUV.y;
	}*/
	
	return sliceUV;
}


void fragment(){
	vec2 samp;
	vec2 uv;
	uv = UV;
	if (!enabled){
		COLOR = texture(TEXTURE, uv);
		samp = uv;

	} else {
		float texRotationOffset =  triangles? triInRotationOffset : polarInRotationOffset;
		vec2 texOffset = triangles ? triInOffset : polarInOffset;
		vec2 viewOffset = triangles ? triOutOffset : polarOutOffset;
		
		uv = rot(uv, CENTER, texRotationOffset);
		uv = uv + texOffset;

		if (triangles) {
			vec2 res = vec2 (1080., 1080.);
			uv = (uv * res - res.xy*0.5)/min(res.x,res.y);
			
			uv = (uv - CENTER) * texMultiplier + CENTER;
			samp = triangleUV(uv, res);
		} else {
			samp = sliceUV(uv);
			
			if (show_slice_only){
			if (!inOriginalSlice(UV)){
				discard;
			}
	}
		}
	    samp = rot(samp, vec2(0.5), viewRotationOffset);
		if (rotation_speed > 0.){
		samp = rot (samp, vec2(0.5), TIME * rotation_speed);
		}
		samp += viewOffset;
		samp = (samp - CENTER) * zoom + CENTER;
	COLOR = texture(TEXTURE, samp);// vec4(UV,0, 1.0);	
		//if (uvRadius < normality_radius){
	if (normality_radius > 0.){
		vec2 c = triangles? uv - CENTER : uv - CENTER;
		float dist = sqrt(dot(c,c));
		float fade = smoothstep (normality_radius - .1, normality_radius,  dist);
		
		samp =  mix(uv, samp, fade);
		COLOR = texture(TEXTURE, samp);// vec4(UV,0, 1.0);	
		if (triangles) {
			vec4 normalCol = texture (TEXTURE, UV);
			COLOR = mix (COLOR, normalCol, 1. - fade);
		}
	}
	//}
	
		
	}

	
	if (show_debug){
		//vec2 p = cartToPolarUV(uv, CENTER);
		//COLOR = texture(TEXTURE, polarToCartUV(p.y, p.x, CENTER));
		COLOR = debugUV(UV, COLOR);
	}
	
	COLOR = vec4(color_channel(COLOR.xyz), 1.0);
	
	if (vignette_radius > 0.){
		COLOR = vignette(samp, COLOR)
	}
	
}