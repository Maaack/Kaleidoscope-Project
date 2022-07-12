extends Viewport


const ROTATION_3D_MOD = 4

var next_rotation = 0 # the next rotation to apply to the tumbler

func _physics_process(delta : float) -> void:
	if $TumblerScene is Spatial: # bit hacky for now, but didn't want to duplicate code
		$TumblerScene/CircularTumbler3D.rotate_z(next_rotation * delta * ROTATION_3D_MOD)
	else:
		$TumblerScene.rotate(next_rotation * delta)
	next_rotation = 0
