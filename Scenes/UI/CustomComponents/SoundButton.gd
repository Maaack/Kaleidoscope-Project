# a button which plays a sound effect when clicked
class_name SoundButton
extends Button

func _pressed():
	$ClickAkEvent2D.post_event()

func _on_SoundButton_mouse_entered():
	if disabled:
		return
	$HoverAkEvent2D.post_event()
