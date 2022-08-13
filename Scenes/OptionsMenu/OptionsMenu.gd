extends Control

const MASTER_AUDIO_BUS = AK.GAME_PARAMETERS.BUSVOLUME_MASTER
const SFX_AUDIO_BUS = AK.GAME_PARAMETERS.BUSVOLUME_SFX
const MUSIC_AUDIO_BUS = AK.GAME_PARAMETERS.BUSVOLUME_MUSIC
const AUDIO_SECTION = 'AudioSettings'

const FULLSCREEN_ENABLED = 'FullscreenEnabled'
const VIDEO_SECTION = 'VideoSettings'

onready var master_slider = $"%MasterHSlider"
onready var sfx_slider = $"%SFXHSlider"
onready var music_slider = $"%MusicHSlider"
onready var mute_button = $"%MuteButton"

export(float, 0.0, 10.0) var audio_warm_up : float = 2.0

var is_warming_up : bool = false
var audio_warm_up_timer : float = 0.0

func _get_bus(ak_bus_id : int) -> float:
	return Wwise.get_rtpc_id(ak_bus_id, null)

func _set_bus(ak_bus_id : int, value : float) -> void:
	if is_warming_up:
		return
	Wwise.set_rtpc_id(ak_bus_id, value, null)
	Config.set_config(AUDIO_SECTION, str(ak_bus_id), value)

func _update_ui():
	master_slider.value = _get_bus(MASTER_AUDIO_BUS)
	sfx_slider.value = _get_bus(SFX_AUDIO_BUS)
	music_slider.value = _get_bus(MUSIC_AUDIO_BUS)
	$FullscreenControl/FullscreenButton.pressed = OS.window_fullscreen

func _set_fullscreen_enabled(value : bool) -> void:
	OS.window_fullscreen = value
	Config.set_config(VIDEO_SECTION, FULLSCREEN_ENABLED, value)

func _set_init_config_if_empty() -> void:
	if not Config.has_section(VIDEO_SECTION):
		Config.set_config(VIDEO_SECTION, FULLSCREEN_ENABLED, OS.window_fullscreen)
	if not Config.has_section(AUDIO_SECTION):
		Config.set_config(AUDIO_SECTION, str(MASTER_AUDIO_BUS), _get_bus(MASTER_AUDIO_BUS))
		Config.set_config(AUDIO_SECTION, str(SFX_AUDIO_BUS), _get_bus(SFX_AUDIO_BUS))
		Config.set_config(AUDIO_SECTION, str(MUSIC_AUDIO_BUS), _get_bus(MUSIC_AUDIO_BUS))

func _set_audio_buses_from_config() -> void:
	var master_audio_value : float = _get_bus(MASTER_AUDIO_BUS)
	var sfx_audio_value : float = _get_bus(SFX_AUDIO_BUS)
	var music_audio_value : float = _get_bus(MUSIC_AUDIO_BUS)
	master_audio_value = Config.get_config(AUDIO_SECTION, str(MASTER_AUDIO_BUS), master_audio_value)
	sfx_audio_value = Config.get_config(AUDIO_SECTION, str(SFX_AUDIO_BUS), sfx_audio_value)
	music_audio_value = Config.get_config(AUDIO_SECTION, str(MUSIC_AUDIO_BUS), music_audio_value)
	_set_bus(MASTER_AUDIO_BUS, master_audio_value)
	_set_bus(SFX_AUDIO_BUS, sfx_audio_value)
	_set_bus(MUSIC_AUDIO_BUS, music_audio_value)

func _set_fullscreen_enabled_from_config() -> void:
	var fullscreen_enabled : bool = OS.window_fullscreen
	fullscreen_enabled = Config.get_config(VIDEO_SECTION, FULLSCREEN_ENABLED, fullscreen_enabled)
	OS.window_fullscreen = fullscreen_enabled

func _start_warm_up() -> void:
	is_warming_up = true
	audio_warm_up_timer = 0.0

func _sync_with_config() -> void:
	_set_init_config_if_empty()
	_set_fullscreen_enabled_from_config()
	_set_audio_buses_from_config()
	_start_warm_up()

func _warming_up_calls() -> void:
	_update_ui()

func _warm_up(delta : float) -> void:
	if not is_warming_up:
		return
	audio_warm_up_timer += delta
	if audio_warm_up_timer >= audio_warm_up:
		is_warming_up = false
		return
	_warming_up_calls()

func _ready():
	_sync_with_config()

func _process(delta):
	_warm_up(delta)

func _on_MasterHSlider_value_changed(value):
	_set_bus(MASTER_AUDIO_BUS, value)

func _on_SFXHSlider_value_changed(value):
	_set_bus(SFX_AUDIO_BUS, value)

func _on_MusicHSlider_value_changed(value):
	_set_bus(MUSIC_AUDIO_BUS, value)

func _on_MuteButton_toggled(button_pressed):
	pass
	# disabling for now
	# Wwise.set_rtpc_id(AK.GAME_PARAMETERS.BUSVOLUME_MASTER, 0.0 if button_pressed else $MasterControl/MasterHSlider.value, null)

func _on_FullscreenButton_toggled(button_pressed):
	_set_fullscreen_enabled(button_pressed)
