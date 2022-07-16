extends Spatial

signal mushroom_eated
signal player_started_looking_at(object)
signal player_stopped_looking_at(object)

var can_pause = true # to prevent from instantly repausing after unpaused from the pause menu by pressing ui_cancel
var collision_viewer_types = {0: "RED" , 1: "GREEN", 2: "BLUE", 3: "MUSHROOM"} # list of types defined in ViewColiider

func _process(_delta):
	# cannot repause before releasing the key once
	if Input.is_action_just_pressed("ui_cancel") and can_pause:
		can_pause = false
		PauseMenuController.paused = true
	else:
		can_pause = true


func _on_Player_Controller_started_looking_at(object):
	emit_signal("player_started_looking_at", object)


func _on_Player_Controller_stopped_looking_at(object):
	emit_signal("player_stopped_looking_at", object)


func _on_Player_Controller_interacted_with(object : ViewCollider):
	if object.collider_type == ViewCollider.Type.MUSHROOM:
		emit_signal("mushroom_eated")


