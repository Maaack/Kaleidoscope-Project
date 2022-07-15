# a button which can play a sound effect when clicked
class_name SoundButton
extends Button

export(AudioStream) var sound_effect


func _ready():
	$AudioStreamPlayer.stream = sound_effect


func _on_Button_pressed():
	$AudioStreamPlayer.play()
