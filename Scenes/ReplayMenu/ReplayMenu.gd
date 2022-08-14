extends Control

var selected_file : Button
var dir = Directory.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	dir.open("user://")
	update_file_list()
	$VBoxContainer/ButtonsContainer/SaveButton.disabled = PlayerRecorder.previous_recorded_frames.size() == 0


func _notification(what):
	if what == NOTIFICATION_WM_FOCUS_IN:
		update_file_list() # update file list after user go back to the game because the player can have removed file in the OS file manager


func update_file_list():
	if $VBoxContainer/ScrollContainer/FilesContainer.get_child_count() > 0:
		for child in $VBoxContainer/ScrollContainer/FilesContainer.get_children():
			child.free()
	
	# get list of files, skipping navigationnal and hidden files
	dir.list_dir_begin(true, true)
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		
		# skip directories
		if dir.current_is_dir():
			continue
		
		if file_name.ends_with(".ctpbck"):
			var button = Button.new()
			button.text = file_name
			button.connect("pressed", self, "_on_file_button_pressed", [button])
			$VBoxContainer/ScrollContainer/FilesContainer.add_child(button)


func _on_file_button_pressed(selected):
	selected_file = selected


func _on_PlayButton_pressed():
	if selected_file:
		PlayerRecorder.load_recorded_from_disk(selected_file.text)
		SceneLoader.load_scene("res://Scenes/ReplayMenu/ReplayScene.tscn")


func _on_DeleteButton_pressed():
	if selected_file:
		dir.remove(selected_file.text)
		selected_file.free()
		selected_file = null


func _on_SaveButton_pressed():
	PlayerRecorder.save_recorded_to_disk()
	update_file_list()
	$VBoxContainer/ButtonsContainer/SaveButton.disabled = true


func _on_OpenFolderButton_pressed():
	OS.shell_open(str("file://", ProjectSettings.globalize_path("user://")))
