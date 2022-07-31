extends Spatial

func _ready():
	#Testing Auto Follow
	$Player.set_followed_path($FollowedPath)
	pass
