tool
extends KinematicBody


export(float) var radius : float = 10.0 setget set_radius
export(int) var segments : int = 32
export(Shape) var edge_shape : Shape = BoxShape.new()

func _place_collision_shapes_in_circle():
	for i in range(segments):
		var circle_position : float = float(i) / float(segments)
		var new_collision_shape = CollisionShape.new()
		new_collision_shape.shape = edge_shape
		new_collision_shape.translation.x = sin( circle_position * PI * 2.0 ) * radius
		new_collision_shape.translation.y = cos( circle_position * PI * 2.0 ) * radius
		new_collision_shape.rotation.z = -( circle_position * PI * 2.0 )
		add_child(new_collision_shape)

func _clear_children():
	for child in get_children():
		child.queue_free()

func set_radius(value : float) -> void:
	radius = value
	if radius == null:
		return
	_clear_children()
	_place_collision_shapes_in_circle()

func set_segments(value : int) -> void:
	segments = value
	if segments == null:
		return
	_clear_children()
	_place_collision_shapes_in_circle()

func _ready():
	_place_collision_shapes_in_circle()
