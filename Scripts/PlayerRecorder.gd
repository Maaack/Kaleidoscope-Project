extends Node

signal playback_ended

var recorded_frames = []
var previous_recorded_frames : Array
var recording = false setget set_recording
var playing_back = false setget set_playing_back


func _physics_process(delta):
	if not(recording or playing_back): return
	
	var player = get_player()
	if not player: return
	
	if recording:
		recorded_frames.append_array([player.translation, player.rotation, player.get_node("Pivot/PlayerCamera").rotation])
	elif playing_back and recorded_frames.size() > 0:
		var frame = recorded_frames.pop_front()
		player.translation = frame[0]
		player.rotation = frame[1]
		player.get_node("Pivot/PlayerCamera").rotation = frame[2]
		
		if recorded_frames.size() == 0:
			emit_signal("playback_ended")
	


func save_recorded_to_disk():
	var file_name = str("Record-", Time.get_datetime_string_from_system(), ".ctpbck").replace(":", "-")
	var file = File.new()
	file.open("user://" + file_name, File.WRITE)
	file.store_buffer(PoolByteArray(previous_recorded_frames))
	file.close()


func load_recorded_from_disk(file_name):
	var file = File.new()
	if file.file_exists(file_name):
		file.open("user://" + file_name, File.READ)
		recorded_frames = Array(file.get_buffer(file.get_len()))
		recorded_frames.invert()


func set_recording(value):
	recording = value
	if recording:
		recorded_frames = []
	elif recorded_frames.size() > 0:# save the recorded frames so if playback another game from file this one will not be lost
		previous_recorded_frames = recorded_frames.duplicate()


func set_playing_back(value):
	playing_back = value
	if playing_back:
		var player = get_player()
		if player:
			player.playback_mode = true


func get_player() -> KinematicBody :
	var player_list = get_tree().get_nodes_in_group("Player") # should only have one
	return player_list[0] if player_list.size() > 0 else null
