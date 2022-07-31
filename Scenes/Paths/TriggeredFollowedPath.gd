tool
extends FollowedPath

export(Shape) var trigger_area : Shape setget set_trigger_area

func set_trigger_area(value : Shape) -> void:
	trigger_area = value
	var trigger_shape = get_node_or_null("TriggerArea/CollisionShape")
	if trigger_area == null or trigger_shape == null:
		trigger_shape.shape = null
		return
	trigger_shape.shape = trigger_area


func _on_TriggerArea_body_entered(body):
	if body.has_method("set_followed_path"):
		body.set_followed_path(self)
