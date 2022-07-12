extends CanvasLayer


var showing_pattern : bool = false

func _process(_delta : float):
	if Input.is_action_just_pressed("toggle_show_pattern"):
		if showing_pattern:
			$AnimationPlayer.play_backwards("show")
		else:
			$AnimationPlayer.play("show")
			
		showing_pattern = !showing_pattern
