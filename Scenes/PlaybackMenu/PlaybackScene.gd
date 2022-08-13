extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerRecorder.connect("playback_ended", self, "_on_playback_ended")
	PlayerRecorder.playing_back = true


func _on_playback_ended():
	get_tree().change_scene("res://Scenes/MainMenu/MainMenu.tscn")
