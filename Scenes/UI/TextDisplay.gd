extends CanvasLayer

const min_display_time = 2 # in seconds
const display_time_ratio = 0.1 # how many time should the text be displayed by number of characters

func display_text(text : String) -> void:
	$Timer.stop()
	$Label.text = text
	$Timer.start( max(text.length() * display_time_ratio, min_display_time) )
	$AnimationPlayer.play("FadeIn")


func _on_Timer_timeout():
	$AnimationPlayer.play_backwards("FadeIn")
