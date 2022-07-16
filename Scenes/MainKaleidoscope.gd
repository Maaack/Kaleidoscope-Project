extends Node




func _on_DreamscapeInteractive_player_started_looking_at(object : ViewCollider):
	if object:
		$TextDisplay.display_text("Looking at %s" % ViewCollider.Type.keys()[object.collider_type])


func _on_DreamscapeInteractive_player_stopped_looking_at(object : ViewCollider):
	pass # Replace with function body.
