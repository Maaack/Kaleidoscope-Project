extends Spatial

onready var original_color = $PlaceHolder.material.albedo_color


func _on_ViewCollider_looked_at():
	$PlaceHolder.material.albedo_color = Color.aqua


func _on_ViewCollider_stop_looked_at():
	$PlaceHolder.material.albedo_color = original_color


func _on_ViewCollider_interacted():
	$AkEvent.post_event()
	$PlaceHolder.visible = false
	$ViewCollider/CollisionShape.disabled = true
