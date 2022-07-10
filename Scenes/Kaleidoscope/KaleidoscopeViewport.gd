extends ViewportContainer
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
		print(x_speed)
		next_rotation = clamp(x_speed, -MAX_ROTATION_STEP, MAX_ROTATION_STEP)
