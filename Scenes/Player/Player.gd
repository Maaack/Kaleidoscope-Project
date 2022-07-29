extends KinematicBody

signal interactable_entered(interactable_text)
signal interactable_exited(interactable_text)
signal interacted(interactable_type)

const NONE_INTERACTABLE_TYPE = 0

export(float, 0.0, 5.0) var footstep_vector_min : float = 2.0
export(float, 0.0, 10.0) var jogging_vector_min : float = 5.0

onready var camera = $Pivot/PlayerCamera
onready var path_follower = $PathFollow;

var path_node;
var path_node_beginning;
var path_node_end;
var reverse_direction = false;

var gravity = -30
var max_speed = 6
var jump_force = 0
var current_interactable

#camera vars
var mouse_sensitivity : float = 0.02  #radians/pixel
var minLookAngle : float = -90
var maxLookAngle : float = 90

var velocity = Vector3()
var mouseDelta = Vector2()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func set_current_path(path):
	path_node = path;
	path_node_beginning = path_node.get_curve().get_point_position(0);
	path_node_end = path_node.get_curve().get_point_position(path_node.get_curve().get_point_count()-1)
	path_follower.get_parent().remove_child(path_follower)
	path_node.add_child(path_follower);

func get_input():
	var input_dir = Vector3()
	# desired move in camera direction
	if Input.is_action_pressed("move_forward"):
		input_dir += -global_transform.basis.z
	if Input.is_action_pressed("move_back"):
		input_dir += global_transform.basis.z
	if Input.is_action_pressed("move_left"):
		input_dir += -global_transform.basis.x
	if Input.is_action_pressed("move_right"):
		input_dir += global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir
	
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		self.rotate_y(deg2rad(event.relative.x * mouse_sensitivity * -6))
		camera.rotate_x(deg2rad(event.relative.y * mouse_sensitivity * -6))
		camera.rotation.x = clamp(camera.rotation.x, -0.90, 1)

func _physics_process(delta):
	velocity.y += gravity * delta
	if (path_node && Input.is_action_pressed("auto_walk")):
		if (Input.is_action_just_pressed("auto_walk")):
			path_follower.set_offset(
				path_node.get_curve().get_closest_offset(global_transform.origin)
			)
			# check which direction we're facing the most and go towards that point
			var forward = -global_transform.basis.z
			var begin_offset = ( path_node_beginning 
				- global_transform.origin).normalized()
			var end_offset = (path_node_end 
				- global_transform.origin).normalized()
			var beginDot = forward.dot(begin_offset)
			var endDot = forward.dot(end_offset)

			if (endDot < 0 && beginDot > 0):
				reverse_direction = true
			else:
				reverse_direction = false
		else:
			var spd = max_speed 
			if reverse_direction:
				spd = -spd
			path_follower.set_offset (path_follower.get_offset() + delta * spd )
			velocity = path_follower.get_child(0).global_transform.origin - global_transform.origin
			velocity = move_and_slide(velocity, Vector3.UP, true)
	else:
		var desired_velocity = get_input() * max_speed

		velocity.x = desired_velocity.x
		velocity.z = desired_velocity.z
		velocity = move_and_slide(velocity, Vector3.UP, true)
	var walk_detection : Vector3 = velocity * Vector3(1, 0, 1)
	if walk_detection.length_squared() > jogging_vector_min:
		$AnimationPlayer.play("Jogging")
	elif walk_detection.length_squared() > footstep_vector_min:
		$AnimationPlayer.play("Walking")

	if Input.is_action_just_pressed("interact") and current_interactable != null:
		if current_interactable is Interactable3D:
			var interactable_type : int = current_interactable.interactable_type
			var interactable_text : String = current_interactable.interactable_text
			current_interactable.interact()
			current_interactable = null
			emit_signal("interacted", interactable_type)
			emit_signal("interactable_exited", interactable_text)
			

func slow_down():
	max_speed = 2

func _on_PlayerCamera_interactable_entered(interactable_node):
	current_interactable = interactable_node
	if current_interactable == null:
		return
	if current_interactable is Interactable3D:
		emit_signal("interactable_entered", current_interactable.interactable_text)

func _on_PlayerCamera_interactable_exited(interactable_node):
	if current_interactable == null or current_interactable != interactable_node:
		return
	if current_interactable is Interactable3D:
		emit_signal("interactable_exited", current_interactable.interactable_text)
	current_interactable = null
