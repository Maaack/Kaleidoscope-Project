extends CanvasLayer

signal tumbler_selected(tumbler)

var showing_pattern : bool = false

func _process(_delta : float):
	if Input.is_action_just_pressed("toggle_show_pattern"):
		if showing_pattern:
			$AnimationPlayer.play_backwards("show")
		else:
			$AnimationPlayer.play("show")
			
		showing_pattern = !showing_pattern


func _on_KaleidoscopeSelection_tumbler_selected(tumbler):
	emit_signal("tumbler_selected", tumbler)
