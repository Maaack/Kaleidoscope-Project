extends Node

enum States{
	NONE,
	INTRO,
	MENU,
	CREDITS,
	OPTIONS,
	EXIT
}

export(String) var version_name : String
var menu_state : int = States.NONE

func _ready() -> void:
	Wwise.set_pause_mode(PAUSE_MODE_PROCESS)
	if version_name != "":
		$Control/BordersMarginContainer/Control/VersionName.text = "v %s" % version_name

func _disable_menu_buttons(disabled : bool = true) -> void:
	for node in $Control/CenterMarginContainer/CenterContainer/VBoxContainer.get_children():
		if node is Button:
			node.disabled = disabled

func start_intro():
	menu_state = States.INTRO

func open_menu():
	menu_state = States.MENU
	_disable_menu_buttons(false)

func close_menu():
	_disable_menu_buttons()

func quit():
	close_menu()
	menu_state = States.EXIT
	$MenuAnimationPlayer.play("Outro")
	yield($MenuAnimationPlayer, "animation_finished")
	get_tree().quit()

func _on_QuitButton_pressed():
	quit()

func open_credits():
	close_menu()
	menu_state = States.CREDITS
	$MenuAnimationPlayer.play("OpenCredits")
	$CreditMusicAkEvent2D.post_event()

func close_credits():
	$MenuAnimationPlayer.play("CloseCredits")
	$MenuMusicAkEvent2D.post_event()

func open_options():
	close_menu()
	menu_state = States.OPTIONS
	$MenuAnimationPlayer.play("OpenOptions")

func close_options():
	$MenuAnimationPlayer.play("CloseOptions")

func _on_CreditsButton_pressed():
	open_credits()

func _on_Credits_end_reached():
	close_credits()

func _on_OptionsButton_pressed():
	open_options()

func _on_BackButton_pressed():
	$Control/BackButton.disabled = true
	match(menu_state):
		States.CREDITS:
			close_credits()
		States.OPTIONS:
			close_options()

func _input(event):
	if menu_state == States.INTRO and \
	(event is InputEventMouseButton or \
	event is InputEventKey):
		$MenuAnimationPlayer.seek(4.4)

func _on_PlayButton_pressed():
	menu_state = States.EXIT
	GameLog.set_version_played(version_name)
	$MenuAnimationPlayer.play("Outro")
	yield($MenuAnimationPlayer, "animation_finished")
	SceneLoader.load_scene("res://Scenes/MainKaleidoscope.tscn")

func _on_PlaygroundButton_pressed():
	menu_state = States.EXIT
	GameLog.set_version_played(version_name)
	$MenuAnimationPlayer.play("Outro")
	yield($MenuAnimationPlayer, "animation_finished")
	SceneLoader.load_scene("res://Scenes/Experimental/Marek/PlaygroundWorld.tscn")
