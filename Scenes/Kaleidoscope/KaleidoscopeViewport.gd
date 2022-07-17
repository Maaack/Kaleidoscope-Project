extends Viewport



const ROTATION_3D_MOD = 4
signal tumbler_changed
var next_rotation = 0 # the next rotation to apply to the tumbler


func _physics_process(delta : float) -> void:
	# in case there is no thumbler
	if not get_node_or_null("TumblerScene"):
		return
	
	if $TumblerScene is Spatial: # bit hacky for now, but didn't want to duplicate code
		$TumblerScene/CircularTumbler3D.rotate_z(next_rotation * delta * ROTATION_3D_MOD)
	else:
		$TumblerScene.rotate(next_rotation * delta)
	next_rotation = 0


func change_tumbler(new_tumbler : PackedScene) -> void:
	var instance = new_tumbler.instance()
	instance.name = "TumblerScene"
	
	var old_tumbler = get_node_or_null("TumblerScene")
	if old_tumbler:
		remove_child(old_tumbler)
	
	add_child(instance)
	emit_signal("tumbler_changed")
