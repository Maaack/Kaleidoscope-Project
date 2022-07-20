extends ViewportContainer

signal intensity_changed(intensity)

onready var tumbler = $KaleidoscopeViewport/TumblerScene
onready var kaleidoscopeViewport = $KaleidoscopeViewport

export var intensity_change_rate = 50.0;
export var intensity_min = 0.0;
export var intensity_max = 100.0;
export var intensity_lerp = 0.0
export var  triangles : bool = 0;
export var intensity: float = 0

var lerp_min = 0.0
var lerp_max = 100.0

#shader params
var segments_name = "segments"
var segments_val = 3.0
export var _min_segments = 3.0
export var _max_segments = 16.0

var center_radius_name = "center_radius"
var center_radius_val = 0.33
export var _center_radius_max = 1.0
export var _center_radius_min = 0.15

var reflect_outside_name = "reflect_outside"
var reflect_outside_val: bool = false
export var reflect_outside_thresh = 0.25

var inverse_slice = "select_outside_slice"

var border_radius = "border_radius"

var _normality_name = "normality_radius"
var _normality_val = 0.5
export var _normality_min = 1.0
export var _normality_max = 0.0

var _vignette_name = "_vignette_radius"
var _vignette_val = 0
export var _vingette_min = 0.0
export var _vignette_max = 0.5


var _rotation_speed_name = "rotation_speed"
export var rotation_thresh = 0.5
export var rot_speed_min = 0;
export var rot_speed_max = 0.25;
var _rotation_speed_val = 0;

var _tri_multiplier_name = "texMultiplier"
export var _tri_multiplier_val = 4.0
export var _tri_multiplier_min = 1.0
export var _tri_multiplier_max = 8.0
export var _tri_multiplier_curve = 3.0

var tumbler_enabled = false;
export var tumbler_thresh = 50
export var tumbler_speed = 0.25

var time = 0.0

var kaleidoscope_enabled: bool = false
export var enabled_thresh = 0.01

var _changing_intensity_range = false;

func start_kaleidoscope():
	kaleidoscope_enabled = true;
	material.set_shader_param("enabled", true)

	
func reset_kaleidoscope():
	time = 0.0
	intensity = 0.0
	lerp_intensity(0.0)
	
func stop_kaleidoscope():
	reset_kaleidoscope();
	kaleidoscope_enabled = false;
	material.set_shader_param("enabled", false)


func set_range(i_min, i_max):

	#intensity_lerp = intensity
	intensity_min = i_min
	intensity_max = i_max
	#_changing_intensity_range = true
	if (intensity < intensity_min):
		#set_intensity(intensity_min)
		lerp_min = intensity
		lerp_max = i_min+0.1
		_changing_intensity_range = true
	elif (intensity > intensity_max):
		#set_intensity(intensity_max)
		lerp_min = intensity
		lerp_max = i_max-1
		_changing_intensity_range = true
	else:
		lerp_min = i_min
		lerp_max = i_max
	time = 0.0
		
	
func inv_lerp(a, b, v):
	return (v - a ) / (b - a)
	
func set_intensity (i):
	var t = inv_lerp(0.0, 100.0, i)
	lerp_intensity(t)
	
func lerp_intensity_in_range(tr):
	var target_intensity = lerp(lerp_min, lerp_max, tr)
	var t = inv_lerp(0.0, 100.0, target_intensity)
	lerp_intensity(t)
	if (_changing_intensity_range):
		if (intensity >= intensity_min && intensity <= intensity_max):
			_changing_intensity_range = false
			set_range(intensity_min, intensity_max)
		

func lerp_intensity(t):
	intensity = lerp(0.0, 100.0, t);
	segments_val = lerp (_min_segments, _max_segments, ease(t, 3));
	center_radius_val = lerp (_center_radius_min, _center_radius_max, 1.0 - t)
	reflect_outside_val = t > reflect_outside_thresh;
	_tri_multiplier_val = lerp(_tri_multiplier_min, _tri_multiplier_max, ease(t, _tri_multiplier_curve))
	
	_normality_val = lerp(_normality_min, _normality_max, t * 2.0);
	_vignette_val = lerp(_vingette_min, _vignette_max, t * 2.0 );
	
	if (t > rotation_thresh):
		_rotation_speed_val = lerp (rot_speed_min, rot_speed_max, (t - rotation_thresh) / rotation_thresh );
	
	_set_shader()
	_set_tumbler()
	emit_signal("intensity_changed", intensity)
	
	
func _set_shader():
	material.set_shader_param("enabled", kaleidoscope_enabled);
	material.set_shader_param("triangles", triangles)
	material.set_shader_param(segments_name, segments_val)
	material.set_shader_param(center_radius_name, center_radius_val)
	material.set_shader_param(reflect_outside_name, reflect_outside_val)

	material.set_shader_param(_tri_multiplier_name, _tri_multiplier_val)
	material.set_shader_param(_rotation_speed_name, _rotation_speed_val)
	material.set_shader_param(_normality_name, _normality_val)
	material.set_shader_param(_vignette_name, _vignette_val)

func _set_tumbler():
	#TODO: This seems hacky?
	if (intensity > tumbler_thresh):
		tumbler.show();
	else:
		pass
		tumbler.hide();
	kaleidoscopeViewport.next_rotation = tumbler_speed;	
	
	
		
func _ready():
	stop_kaleidoscope() # Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _pulse():
	#const float pi = 3.14;
	#const float frequency = 10; // Frequency in Hz
	return abs( sin(2 * PI * time / intensity_change_rate))
		#return 0.5*(1+sin(2 * PI * intensity_change_rate * time))

func _process(delta):
	if (kaleidoscope_enabled):
		time += delta
		var t = _pulse()
		lerp_intensity_in_range(t)#sin(time / intensity_change_rate) )

func _on_change_intensity(value):
	set_intensity(value)

func _on_shader_selected(index):
	pass

func _on_DreamscapeInteractive_mushroom_eated():
	pass
	#reset_kaleidoscope();
	#start_kaleidoscope();



func _on_KaleidoscopeViewport_tumbler_changed():
	tumbler = $KaleidoscopeViewport/TumblerScene
