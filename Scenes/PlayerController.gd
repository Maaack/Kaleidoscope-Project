extends Spatial

signal started_looking_at(object)

var looking_at : Area

func _physics_process(_delta):
	if looking_at != $Player/Pivot/Camera/LookingAtRayCast.get_collider():
		if looking_at:
			looking_at.emit_signal("stop_looked_at")
		looking_at = $Player/Pivot/Camera/LookingAtRayCast.get_collider()
		emit_signal("started_looking_at", looking_at)
		if looking_at:
			looking_at.emit_signal("looked_at")
