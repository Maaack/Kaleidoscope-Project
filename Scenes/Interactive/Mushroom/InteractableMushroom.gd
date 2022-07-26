tool
extends Interactable3D


func interact() -> void:
	$EatMushroomAkEvent.post_event()
	hide()
