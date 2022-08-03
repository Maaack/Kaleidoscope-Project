extends "res://Scripts/InteractionController.gd"



func _on_ResetArea_body_entered(body):
	if body is PhysicsBody:
		body.global_transform.origin = global_transform.origin + Vector3(0, 5, 0)
