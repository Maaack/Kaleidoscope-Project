extends CanvasLayer

const min_display_time = 2 # in seconds
const display_time_ratio = 0.2 # how many time should the text be displayed by number of characters

func display_text(text : String) -> void:
	$Timer.stop()
	$Label.text = text
	$Timer.start( max(text.length() * display_time_ratio, min_display_time) )
	$AnimationPlayer.play("FadeIn")


func _on_Timer_timeout():
	$AnimationPlayer.play_backwards("FadeIn")

func started_looking_at(object : ViewCollider) -> void:
	if object == null:
		$Timer.stop()
		$AnimationPlayer.play_backwards("FadeIn")
		return
	display_text(object.look_text)#("Looking at %s" % ViewCollider.Type.keys()[object.collider_type])
