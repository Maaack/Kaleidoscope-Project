extends ViewportContainer


<<<<<<< Updated upstream
func _process(_delta : float) -> void:
	var center_point : Vector2 = rect_size / 2.0
	var mouse_angle : float = center_point.angle_to_point(get_global_mouse_position())
	$Viewport/TumblerScene.rotation = mouse_angle
=======

func _physics_process(delta : float) -> void:
	if $Viewport/TumblerScene is Spatial: # bit hacky for now, but didn't want to duplicate code
		$Viewport/TumblerScene/CircularTumbler3D.rotate_z(next_rotation * delta * ROTATION_3D_MOD)
	else:
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

>>>>>>> Stashed changes
