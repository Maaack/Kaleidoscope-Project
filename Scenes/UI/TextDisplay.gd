extends CanvasLayer

const min_display_time = 2 # in seconds
const display_time_ratio = 0.2 # how many time should the text be displayed by number of characters

onready var animation_playback = $AnimationTree.get("parameters/playback")

var current_text : String

func display_text(text : String) -> void:
	$Timer.stop()
	$Label.text = text
	$Timer.start( max(text.length() * display_time_ratio, min_display_time) )
	animation_playback.travel("FadeIn")

func fade_out_text() -> void:
	$Timer.stop()
	animation_playback.travel("FadeOut")

func _on_Timer_timeout():
	fade_out_text()

func _on_Player_interactable_entered(interactable_text):
	display_text(interactable_text)

func _on_Player_interactable_exited(interactable_text):
	fade_out_text()

func clear_text() -> void:
	$Label.text = ""
