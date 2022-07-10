extends SoundButton

signal change_tumbler(to)
export var tumbler_scene : PackedScene


func _on_KaleidoscopeButton_pressed():
	emit_signal("change_tumbler", tumbler_scene)
