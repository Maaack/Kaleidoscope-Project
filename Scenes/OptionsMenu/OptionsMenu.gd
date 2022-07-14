extends Control

signal return_button_pressed

const MASTER_AUDIO_BUS = 'Master'
const VOICE_AUDIO_BUS = 'Voice'
const SFX_AUDIO_BUS = 'SFX'
const MUSIC_AUDIO_BUS = 'Music'
const MUTE_SETTING = 'Mute'

onready var master_slider = $MasterControl/MasterHSlider
onready var sfx_slider = $SFXControl/SFXHSlider
onready var voice_slider = $VoiceControl/VoiceHSlider
onready var music_slider = $MusicControl/MusicHSlider
onready var mute_button = $MuteControl/MuteButton

func _get_bus_volume_2_linear(bus_name : String) -> float:
	var bus_index : int = AudioServer.get_bus_index(bus_name)
	var volume_db : float = AudioServer.get_bus_volume_db(bus_index)
	return db2linear(volume_db)

func _set_bus_linear_2_volume(bus_name : String, linear : float) -> void:
	var bus_index : int = AudioServer.get_bus_index(bus_name)
	var volume_db : float = linear2db(linear)
	AudioServer.set_bus_volume_db(bus_index, volume_db)

func _is_muted() -> bool:
	var bus_index : int = AudioServer.get_bus_index(MASTER_AUDIO_BUS)
	return AudioServer.is_bus_mute(bus_index)

func _set_mute(mute_flag : bool) -> void:
	var bus_index : int = AudioServer.get_bus_index(MASTER_AUDIO_BUS)
	AudioServer.set_bus_mute(bus_index, mute_flag)

func _on_MasterHSlider_value_changed(value):
	_set_bus_linear_2_volume(MASTER_AUDIO_BUS, value)

func _on_SFXHSlider_value_changed(value):
	_set_bus_linear_2_volume(SFX_AUDIO_BUS, value)

func _on_VoiceHSlider_value_changed(value):
	_set_bus_linear_2_volume(VOICE_AUDIO_BUS, value)

func _on_MusicHSlider_value_changed(value):
	_set_bus_linear_2_volume(MUSIC_AUDIO_BUS, value)

func _on_MuteButton_toggled(button_pressed):
	_set_mute(button_pressed)

func _unhandled_key_input(event):
	if event.is_action_released('ui_mute'):
		mute_button.pressed = !(mute_button.pressed)
