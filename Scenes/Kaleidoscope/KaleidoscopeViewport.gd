class_name KaleidoscopeViewport
extends ViewportContainer

const ROTATION_STEP = 3 # rotation step when using keyboard or scroll wheel to move the kaleidoscope
const MAX_ROTATION_STEP = 5 # maximum rotation that can be applied at each movement
const MOUSE_SENSITIVITY = 0.001 # sensitivity of the mouse
const CAPTURED_MOUSE_SENSITIVITY = 0.5# sensitivity of the mouse in captured mode (somewhat the speed is different in each mode)

var next_rotation = 0 # the next rotation to apply to the tumbler


func _physics_process(delta : float) -> void:
	$Viewport/TumblerScene.rotate(next_rotation * delta)
	next_rotation = 0


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


func change_tumbler_scene_to(to : PackedScene):
	var instance = to.instance()
	instance.name = "TumblerScene"
	
	var old_tumbler = get_node_or_null("TumblerScene")
	if old_tumbler:
		remove_child(old_tumbler)
		old_tumbler.queue_free()
	add_child(instance)
