extends "res://Scripts/InteractionController.gd"


func _ready():
	$Player.set_followed_path($FollowedPath)
