tool
extends Spatial

signal interacted

export(float, 0, 1) var hue = 0.0 setget set_hue
export(ViewCollider.Type) var collider_type setget set_collider_type


func set_hue(value : float) -> void:
	hue = value
	$Bar.material.albedo_color.h = hue
	$Light.light_color.h = hue

func set_collider_type(value : int) -> void:
	collider_type = value
	$ViewCollider.collider_type = collider_type

func _on_ViewCollider_interacted():
	$DepositAkEvent.post_event()
	emit_signal("interacted")

func show() -> void:
	.show()
	$ViewCollider/CollisionShape.disabled = false
	$HummingAkEvent.post_event()

func hide() -> void:
	.hide()
	$ViewCollider/CollisionShape.disabled = true
	$HummingAkEvent.stop_event()
