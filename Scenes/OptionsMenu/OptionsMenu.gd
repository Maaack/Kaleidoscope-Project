extends Control


func _ready():
	$MasterControl/MasterHSlider.value = Wwise.get_rtpc_id(AK.GAME_PARAMETERS.BUSVOLUME_MASTER, null)
	$SFXControl/SFXHSlider.value = Wwise.get_rtpc_id(AK.GAME_PARAMETERS.BUSVOLUME_SFX, null)
	$MusicControl/MusicHSlider.value = Wwise.get_rtpc_id(AK.GAME_PARAMETERS.BUSVOLUME_MUSIC, null)


func _on_MasterHSlider_value_changed(value):
	Wwise.set_rtpc_id(AK.GAME_PARAMETERS.BUSVOLUME_MASTER, value, null)


func _on_SFXHSlider_value_changed(value):
	Wwise.set_rtpc_id(AK.GAME_PARAMETERS.BUSVOLUME_SFX, value, null)


func _on_MusicHSlider_value_changed(value):
	Wwise.set_rtpc_id(AK.GAME_PARAMETERS.BUSVOLUME_MUSIC, value, null)


func _on_MuteButton_toggled(button_pressed):
	Wwise.set_rtpc_id(AK.GAME_PARAMETERS.BUSVOLUME_MASTER, 0.0 if button_pressed else $MasterControl/MasterHSlider.value, null)

