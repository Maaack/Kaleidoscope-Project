extends Viewport


const ROTATION_3D_MOD = 4

var next_rotation = 0 # the next rotation to apply to the tumbler

func _physics_process(delta : float) -> void:
	$TumblerScene.rotate(next_rotation * delta)
	next_rotation = 0
