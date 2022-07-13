extends Node

# add a gemstone into the tumbler at specified position
func add_gemstone(gemstone : PackedScene, position : Vector2 = Vector2.ZERO) -> void:
	var tumbler = get_node_or_null("KaleidoscopeViewport/TumblerScene")
	if tumbler:
		tumbler.add_gemstone(gemstone, position)


# remove a gemstone fomr the tumbler
func remove_gemstone(gemstone : RigidBody2D) -> void:
	var tumbler = get_node_or_null("KaleidoscopeViewport/TumblerScene")
	if tumbler:
		tumbler.remove_gemstone(gemstone)


# return an array containing the gemstones childrens of the tumbler
func get_gemstones() -> Array:
	var gemstones = []
	var tumbler = get_node_or_null("KaleidoscopeViewport/TumblerScene")
	if tumbler:
		gemstones =  tumbler.get_gemstones()
	return gemstones



func _on_KaleidoscopeControl_player_rotated(rotation):
	$KaleidoscopeViewport.next_rotation = rotation
