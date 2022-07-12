extends Node2D


# make all the RigidBodies (Gemstones) to static mode so they don't fall to gravity
func _ready():
	for child in get_children():
		if child is RigidBody2D:
			child.mode = RigidBody2D.MODE_STATIC

