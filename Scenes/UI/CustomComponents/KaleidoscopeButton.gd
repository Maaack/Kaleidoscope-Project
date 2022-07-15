extends SoundButton

signal tumbler_selected(tumbler)
export var tumbler_scene : PackedScene


func _on_KaleidoscopeButton_pressed():
	if tumbler_scene:
		emit_signal("tumbler_selected", tumbler_scene)
