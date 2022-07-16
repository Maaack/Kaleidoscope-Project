extends Control


signal player_rotated(rotation)

const ROTATION_STEP = 3 # rotation step when using keyboard or scroll wheel to move the kaleidoscope
const MAX_ROTATION_STEP = 5 # maximum rotation that can be applied at each movement
const MOUSE_SENSITIVITY = 0.001 # sensitivity of the mouse
const CAPTURED_MOUSE_SENSITIVITY = 0.5# sensitivity of the mouse in captured mode (somewhat the speed is different in each mode)

var next_rotation : float

#TODO Performance issues with this code!
""""
func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		var x_speed : float
		
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			x_speed = event.relative.x * CAPTURED_MOUSE_SENSITIVITY
		else:
			x_speed = event.speed.x * MOUSE_SENSITIVITY
		next_rotation = clamp(x_speed, -MAX_ROTATION_STEP, MAX_ROTATION_STEP)
	

	elif event is InputEventMouseButton or event is InputEventKey:
		if event.get_action_strength("turn_tumbler_right") > 0: #using get_action_strength instead of is_action_pressed so you can keep the key pressed
			next_rotation = ROTATION_STEP
		elif event.get_action_strength("turn_tumbler_left") > 0:
			next_rotation = -ROTATION_STEP

	emit_signal("player_rotated", next_rotation)
	
"""
