extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "t


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	Wwise.set_state_id(AK.STATES.MENUGAME.GROUP, AK.STATES.MENUGAME.STATE.MENU)


func _on_Button2_pressed():
	Wwise.set_state_id(AK.STATES.MENUGAME.GROUP, AK.STATES.MENUGAME.STATE.GAME)


func _on_Button3_pressed():
	Wwise.set_state_id(AK.STATES.MENUGAME.GROUP, AK.STATES.MENUGAME.STATE.CREDITS)


func _on_Button4_pressed():
	Wwise.set_state_id(AK.STATES.MENUGAME.GROUP, AK.STATES.MENUGAME.STATE.OUTRO)


