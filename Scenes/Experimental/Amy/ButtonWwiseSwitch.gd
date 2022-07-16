extends Button


# Mike's gdscript experimenting file
# The # characters make a line a "comment" from that point forward

# What you probably want to do instead of Switch() is
# $AkSwitch.set_switch()
# You'll need to add the AkSwitch to your button scene,
# and set what it is meant to switch.


# Called when the node enters the scene tree for the first time.
func _pressed():
	Switch():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
