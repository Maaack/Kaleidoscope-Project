extends ViewportContainer

export(int, "Polar", "Triangle") var kaleidoscope_type;


export var intensity: float = 0

#shader params
var segments_name = "segments"
var segments_val = 3.0
export var _min_segments = 3.0
export var _max_segments = 24.0

var center_radius_name = "center_radius"
var center_radius_val = 0.33
export var _center_radius_max = 1.0
export var _center_radius_min = 0.15

var reflect_outside_name = "reflect_outside"
var reflect_outside_val: bool = false
export var reflect_outside_thresh = 0.25

var inverse_slice = "select_outside_slice"

var border_radius = "border_radius"

var _rotation_speed_name = "rotation_speed"
export var rotation_thresh = 0.5
export var rot_speed_min = 0;
export var rot_speed_max = 0.25;
var _rotation_speed_val = 0;

var _tri_multiplier_name = "texMultiplier"
var _tri_multiplier_val = 4.0
export var _tri_multiplier_min = 1.0
export var _tri_multiplier_max = 8.0


var kaleidoscope_enabled: bool = false
export var enabled_thresh = 0.01




func set_intensity(t):
	intensity = lerp(0, 100, t);
	segments_val = lerp (_min_segments, _max_segments, t);
	center_radius_val = lerp (_center_radius_min, _center_radius_max, 1.0 - t)
	reflect_outside_val = t > reflect_outside_thresh;
	_tri_multiplier_val = lerp(_tri_multiplier_min, _tri_multiplier_max, t)
	if (intensity > rotation_thresh):
		_rotation_speed_val = lerp (rot_speed_min, rot_speed_max, (t - rotation_thresh) / rotation_thresh );
	
	kaleidoscope_enabled = t > enabled_thresh
	
	_set_shader()
	
	
func _set_shader():
	material.set_shader_param(segments_name, segments_val)
	material.set_shader_param(center_radius_name, center_radius_val)
	material.set_shader_param(reflect_outside_name, reflect_outside_val)
	material.set_shader_param ("enabled", kaleidoscope_enabled)
	material.set_shader_param(_tri_multiplier_name, _tri_multiplier_val)
	material.set_shader_param(_rotation_speed_name, _rotation_speed_val)
	print (material.get_shader_param(reflect_outside_name))

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta):
	if Input.is_action_just_pressed("toggle_show_kaleidoscope",true):
		var enabled = material.get_shader_param("enabled")
		material.set_shader_param("enabled", !enabled)


func _on_change_intensity(value):
	set_intensity(value)


func _on_shader_selected(index):
	pass # Replace with function body.
