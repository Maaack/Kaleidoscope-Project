# a button which plays a sound effect when clicked
class_name SoundButton
extends Button

func _pressed():
	$AkEvent2D.post_event()
