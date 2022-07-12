extends Viewport


const ROTATION_3D_MOD = 4

var next_rotation = 0 # the next rotation to apply to the tumbler

func _physics_process(delta : float) -> void:
	$TumblerScene/CircularTumbler3D.rotate_z(next_rotation * delta * ROTATION_3D_MOD)
	next_rotation = 0
