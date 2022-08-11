extends Node

var recorded_frames = []
var recording = false setget set_recording


func _physics_process(delta):
	if not recording: return
	
	var player_list = get_tree().get_nodes_in_group("Player") # should only have one
	if player_list.size() == 0: return # exit if no player can be found
	
	var player = player_list[0] as KinematicBody
	recorded_frames.append_array([player.translation, player.rotation])


func set_recording(value):
	recording = value
	if recording:
		recorded_frames = []
	else:
		pass
		 # might add code to save to disk when stop recording here
