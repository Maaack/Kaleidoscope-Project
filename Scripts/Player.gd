extends KinematicBody


onready var camera = $Pivot/Camera

export(float, 0.0, 5.0) var footstep_vector_min : float = 2.0
export(float, 0.0, 5.0) var jogging_vector_min : float = 10.0

var gravity = -30
var max_speed = 6
var jump_force = 0

#camera vars
var mouse_sensitivity : float = 0.02  #radians/pixel
var minLookAngle : float = -90
var maxLookAngle : float = 90

var velocity = Vector3()
var mouseDelta = Vector2()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

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
		
#func _process(delta):
#	camera.rotation_degrees.x -= mouseDelta.y * mouse_sensitivity * delta
#	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
#	rotation_degrees.y -= mouseDelta.x * mouse_sensitivity * delta
#	mouseDelta = Vector2()
		
func _physics_process(delta):
	velocity.y += gravity * delta
	var desired_velocity = get_input() * max_speed

	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
	var walk_detection : Vector3 = velocity * Vector3(1, 0, 1)
	if walk_detection.length_squared() > jogging_vector_min:
		$AnimationPlayer.play("Jogging")
	elif walk_detection.length_squared() > footstep_vector_min:
		$AnimationPlayer.play("Walking")
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_force


func _on_MainKaleidoscope_trip_started():
	max_speed = 2
