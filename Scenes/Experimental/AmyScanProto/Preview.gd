extends ViewportContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Viewport/Picture.hide_target() # Replace with function body.
	$Viewport/Picture.start_cam_follow()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
