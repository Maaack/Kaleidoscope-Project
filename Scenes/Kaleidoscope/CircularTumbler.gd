extends KinematicBody2D


export(float) var radius : float = 300.0
export(int) var segments : int = 32
export(Shape2D) var edge_shape : Shape2D = RectangleShape2D.new()

func _place_collision_shapes_in_circle():
	for i in range(segments):
		var circle_position : float = float(i) / float(segments)
		var new_collision_shape = CollisionShape2D.new()
		new_collision_shape.shape = edge_shape
		new_collision_shape.position.x = sin( circle_position * PI * 2.0 ) * radius
		new_collision_shape.position.y = cos( circle_position * PI * 2.0 ) * radius
		new_collision_shape.rotation = -( circle_position * PI * 2.0 )
		add_child(new_collision_shape)
		
func _ready():
	_place_collision_shapes_in_circle()
