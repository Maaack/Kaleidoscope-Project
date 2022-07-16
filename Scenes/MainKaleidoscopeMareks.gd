extends Node

export(float) var wwise_intensity_scale = 100.0

func _on_Kaleidoscope_intensity_changed(intensity):
	intensity *= wwise_intensity_scale
	Wwise.set_rtpc_id(AK.GAME_PARAMETERS.PLAYERHIGHNESS, intensity, $LevelMusicAkEvent2D)
