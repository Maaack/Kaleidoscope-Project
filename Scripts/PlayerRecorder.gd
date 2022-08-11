extends Node

var recorded_frames = []
var recording = false setget set_recording


func _physics_process(delta):
	if not recording: return
	
	var player_list = get_tree().get_nodes_in_group("Player") # should only have one
	if player_list.size() == 0: return # exit if no player can be found
	
	var player = player_list[0] as KinematicBody
	recorded_frames.append_array([player.translation, player.rotation])


func save_recorded_to_disk():
	var file_name = str("Record-", Time.get_datetime_string_from_system(), ".ctpbck")
	var file = File.new()
	file.open("user://" + file_name, File.WRITE)
	file.store_buffer(PoolByteArray(recorded_frames))
	file.close()


func load_recorded_from_disk(file_name):
	var file = File.new()
	if file.file_exists(file_name):
		file.open(file_name, File.READ)
		recorded_frames = Array(file.get_buffer(file.get_len()))


func set_recording(value):
	recording = value
	if recording:
		recorded_frames = []
