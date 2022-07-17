extends WorldEnvironment


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func start_trip():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MainKaleidoscope_trip_started():
	$AnimationPlayer.play("GettingPumped")


func _on_MainKaleidoscope_trip_ended():
	$AnimationPlayer.play_backwards ("GettingPumped")
	yield(get_tree().create_timer(30), "timeout")
	$AnimationPlayer.play_backwards ("FadeOut")
	#END
