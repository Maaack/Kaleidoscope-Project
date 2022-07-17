extends Node

signal trip_started()
signal trip_ended()

onready var kaleidoscope = $Kaleidoscope
onready var tumbler_control = $Kaleidoscope/KaleidoscopeViewport
onready var gem_control = $Kaleidoscope/GemControl

export (PackedScene) var tumbler
export (PackedScene)  var red_gemstone
export (PackedScene) var green_gemstone
export (PackedScene) var blue_gemstone


var ethereal_min = 90
var ethereal_max = 100

var red_gem;
var green_gem;
var blue_gem;

export(NodePath) var red_pillar_path
var red_pillar


export(NodePath) var green_pillar_path
var green_pillar


export(NodePath) var blue_pillar_path
var blue_pillar

export(NodePath) var purple_pillar_path
var purple_pillar

var _enlightened = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	tumbler_control.change_tumbler(tumbler)
		
	red_pillar = get_node_or_null(red_pillar_path) # Replace with function body.
	green_pillar = get_node_or_null(green_pillar_path)
	blue_pillar = get_node_or_null(blue_pillar_path)
	purple_pillar = get_node_or_null(purple_pillar_path)
	
	red_pillar.hide()
	green_pillar.hide()
	blue_pillar.hide()
	purple_pillar.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func get_random_pos():
	return Vector2(rand_range(-80, 80), rand_range(-80, 80))

func add_gems():
	red_gem = gem_control.add_gemstone(red_gemstone, get_random_pos())
	green_gem = gem_control.add_gemstone(green_gemstone, get_random_pos())
	blue_gem = gem_control.add_gemstone(blue_gemstone, get_random_pos())
	kaleidoscope._set_tumbler()
	
func start_trip():
	kaleidoscope.reset_kaleidoscope()
	var transition_rate = kaleidoscope.intensity_change_rate
	kaleidoscope.intensity_change_rate = transition_rate * 2.0
	kaleidoscope.set_range(40, 45)
	#add_gems()
	emit_signal("trip_started")
	yield(get_tree().create_timer(15), "timeout")
	kaleidoscope.start_kaleidoscope()
	yield(get_tree().create_timer(15), "timeout")
	kaleidoscope.intensity_change_rate = transition_rate
	kaleidoscope.set_range(50, 55)
	red_pillar.show()
	
func on_interact_red_pillar():
	red_pillar.hide()
	#gem_control.remove_gemstone(red_gem)
	kaleidoscope.set_range(60, 70)
	green_pillar.show()
	
func on_interact_green_pillar():
	blue_pillar.show()
	#gem_control.remove_gemstone(green_gem)
	kaleidoscope.set_range(60, 78)
	green_pillar.hide()

func on_interact_blue_pillar():
	#gem_control.remove_gemstone(blue_gem)
	blue_pillar.hide()
	on_enlightenment()

func on_enlightenment():
	kaleidoscope.intensity_change_rate = kaleidoscope.intensity_change_rate  * 4.0
	purple_pillar.show()
	kaleidoscope.set_range(95,100)
	_etheral_music()
	_enlightened = true
	yield(get_tree().create_timer(30), "timeout")
	on_clarity()
	
func on_clarity():
	_enlightened = false
	purple_pillar.hide()

	kaleidoscope.set_range(0, 1)
	emit_signal("trip_ended")
	#the end


	
func _on_DreamscapeInteractive_pillar_interaction(pillar):
	match(pillar):
		ViewCollider.Type.RED:
			on_interact_red_pillar()
		ViewCollider.Type.GREEN:
			on_interact_green_pillar()
		ViewCollider.Type.BLUE:
			on_interact_blue_pillar()



func _on_DreamscapeInteractive_mushroom_eated():
	start_trip()


func _on_Kaleidoscope_intensity_changed(intensity):
	if (_enlightened):
		return
	if (intensity > ethereal_min && intensity < ethereal_max):
		intensity = ethereal_max + 1
	Wwise.set_rtpc_id(AK.GAME_PARAMETERS.PLAYERHIGHNESS, intensity, $LevelMusicAkEvent2D)

func _etheral_music():
	Wwise.set_rtpc_id(AK.GAME_PARAMETERS.PLAYERHIGHNESS, (ethereal_max), $LevelMusicAkEvent2D)
