tool
extends Interactable3D

export(float, 0, 1) var hue = 0.0 setget set_hue

func set_hue(value : float) -> void:
	hue = value
	$Bar.material.albedo_color.h = hue
	$Light.light_color.h = hue

func interact():
	$DepositAkEvent.post_event()
	hide()

func show() -> void:
	.show()
	$HummingAkEvent.post_event()

func hide() -> void:
	.hide()
	$HummingAkEvent.stop_event()

func pulse() -> void:
	$PulseAnimationPlayer.play("Pulse")
