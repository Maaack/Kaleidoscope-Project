extends Control


onready var loader = ResourceLoader.load_interactive(SceneLoader.scene_to_load)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var err = loader.poll()
	if err == OK:
		$VBoxContainer/ProgressBar.value = loader.get_stage() * 100 / loader.get_stage_count()
	elif err == ERR_FILE_EOF:
		$VBoxContainer/ProgressBar.value = 100
		get_tree().change_scene_to(loader.get_resource())
	else:
		$ErrorMsg.dialog_text = err
		$ErrorMsg.popup_centered()


func _on_ErrorMsg_confirmed():
	get_tree().change_scene("res://Scenes/MainMenu/MainMenu.tscn")