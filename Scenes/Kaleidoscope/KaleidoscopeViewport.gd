extends ViewportContainer


func _process(_delta : float) -> void:
	var center_point : Vector2 = rect_size / 2.0
	var mouse_angle : float = center_point.angle_to_point(get_global_mouse_position())
	$Viewport/TumblerScene.rotation = mouse_angle
