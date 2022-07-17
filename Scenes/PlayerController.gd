extends Spatial

signal started_looking_at(object)
signal interacted_with(object)

var looking_at : ViewCollider

func _physics_process(_delta):
	if looking_at != $Player/Pivot/Camera/LookingAtRayCast.get_collider():
		if looking_at:
			looking_at.emit_signal("stop_looked_at")
		looking_at = $Player/Pivot/Camera/LookingAtRayCast.get_collider()
		if looking_at and not looking_at.get_parent().visible:
			return
		emit_signal("started_looking_at", looking_at)
		if looking_at:
			looking_at.emit_signal("looked_at")
	
	if Input.is_action_just_pressed("interact") and looking_at:
		looking_at.emit_signal("interacted")
		emit_signal("interacted_with", looking_at)
