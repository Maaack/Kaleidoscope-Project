extends Node
signal on_send_mouse_move(pos)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _cam_follow_on = false

# Called when the node enters the scene tree for the first time.
func _ready():
	start_cam_follow()# Replace with function body.

func hide_target():
	print ("HIDE TARGET")
	$Target.hide();
func show_target():
	$Target.show();
	
func start_cam_follow():
	print ("START CAM")
	_cam_follow_on = true;
	# $Target2/Camera2D.current = true;
	
func _input(event):
	if (!_cam_follow_on):
		return
   # Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position)
		 # print ("Cat Pos: ", $Target.position)
	elif event is InputEventMouseMotion:
		# print ("Motion: ", get_viewport().get_mouse_position())
		var pos = get_viewport().get_mouse_position()
		$Target2.position = pos
		emit_signal("on_send_mouse_move", get_viewport().get_mouse_position())


func _on_Target_Clicked():
	print ("You Found the Cat!");
	$Target.show();

func _on_Picture_on_send_mouse_move(pos):

	$Target2.position = pos
	$"Camera2D".position = pos

