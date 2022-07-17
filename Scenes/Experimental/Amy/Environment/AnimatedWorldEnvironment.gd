extends WorldEnvironment


signal world_ended

func start_trip():
	pass


func _on_MainKaleidoscope_trip_started():
	$AnimationPlayer.play("GettingPumped")


func _on_MainKaleidoscope_trip_ended():
	$AnimationPlayer.play_backwards ("GettingPumped")
	yield(get_tree().create_timer(15), "timeout")
	$AnimationPlayer.play("FadeOut")

func end_world() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	emit_signal("world_ended")
