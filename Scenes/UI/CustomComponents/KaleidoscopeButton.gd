extends SoundButton

signal change_tumbler(to)
export var tumbler_scene : PackedScene


func _on_KaleidoscopeButton_pressed():
	if tumbler_scene:
		emit_signal("change_tumbler", tumbler_scene)
