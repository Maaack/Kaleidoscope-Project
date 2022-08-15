extends Node

const FULLSCREEN_ENABLED = 'FullscreenEnabled'
const VIDEO_SECTION = 'VideoSettings'

func _ready():
	OS.window_fullscreen = Config.get_config(VIDEO_SECTION, FULLSCREEN_ENABLED, true)
	SceneLoader.load_scene("res://Scenes/MainMenu/MainMenu.tscn")
