class_name TumblerSceneBase
extends Node2D

export var static_tumbler = false # if true the gemstone inside this tumbler will not fall to gravity


# make all the RigidBodies (Gemstones) to static mode so they don't fall to gravity
func _ready() -> void:
	if static_tumbler:
		for child in get_children():
			if child is RigidBody2D:
				child.mode = RigidBody2D.MODE_STATIC


# add a gemstone into the tumbler at specified position
func add_gemstone(gemstone : PackedScene, position : Vector2 = Vector2.ZERO) -> void:
	var instance = gemstone.instance() as RigidBody2D
	instance.position = position
	if static_tumbler:
		instance.mode = RigidBody2D.MODE_STATIC
	add_child(instance)


# remove a gemstone fomr the tumbler
func remove_gemstone(gemstone : RigidBody2D) -> void:
	for child in get_children():
		if child == gemstone:
			remove_child(child)
			return


func disable_gemstone(gemstone : RigidBody2D) -> void:
	for child in get_children():
		if child == gemstone:
			child.enabled = false
			return


func enable_gemstone(gemstone : RigidBody2D) -> void:
	for child in get_children():
		if child == gemstone:
			child.enabled = true
			return


func toggle_gemstone(gemstone : RigidBody2D) -> void:
	for child in get_children():
		if child == gemstone:
			child.enabled = !child.enabled
			return


# return an array containing the gemstones childrens
func get_gemstones() -> Array:
	var gemstones = []
	for child in get_children():
		if child is RigidBody2D:
			gemstones.append(child)
	return gemstones
