extends KinematicBody

signal interactable_entered(interactable_text)
signal interactable_exited(interactable_text)
signal interacted(interactable_type)

const NONE_INTERACTABLE_TYPE = 0
const FOOTSTEP_VECTOR_MIN = 2.0
const JOGGING_VECTOR_MIN = 5.0

export(float, -60, 60) var gravity_mod : float = 0.0

onready var camera = $Pivot/PlayerCamera

var followed_path : FollowedPath setget set_followed_path
var path_node_beginning
var path_node_end
var reverse_direction = false

var gravity = -30
var max_speed = 6
var stand_up_colliders : int = 0
var current_interactable

#camera vars
var mouse_sensitivity : float = 0.02  #radians/pixel
var minLookAngle : float = -90
var maxLookAngle : float = 90

var velocity = Vector3()
var mouseDelta = Vector2()

var playback_mode = false # when true the player should ignore user input

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func set_followed_path(value : FollowedPath):
	followed_path = value
	if followed_path == null:
		return
	path_node_beginning = followed_path.get_start_point_position()
	path_node_end = followed_path.get_end_point_position()

func get_input():
	if playback_mode: return
	
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
	if not playback_mode and event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		self.rotate_y(deg2rad(event.relative.x * mouse_sensitivity * -6))
		camera.rotate_x(deg2rad(event.relative.y * mouse_sensitivity * -6))
		camera.rotation.x = clamp(camera.rotation.x, -0.90, 1)

func _get_angle_on_y_axis(to_origin : Vector3):
	var vector_mask : Vector3 = Vector3.FORWARD + Vector3.RIGHT
	var masked_translation : Vector3 = (global_transform.origin - to_origin) * vector_mask
	var cross : Vector3 = Vector3.FORWARD.cross(masked_translation).normalized()
	var angle : float = Vector3.FORWARD.angle_to(masked_translation)
	if cross.y > 0:
		angle *= -1.0
	return angle

func _physics_process(delta):
	if playback_mode: return
	var is_crouched : bool = Input.is_action_pressed("crouch")
	var animation_playback : AnimationNodeStateMachinePlayback = $BodyAnimationTree.get("parameters/playback")
	if is_crouched:
		animation_playback.travel("Crouch")
	elif stand_up_colliders == 0:
		animation_playback.travel("Standing")
	if (followed_path && Input.is_action_pressed("auto_walk")):
		#followed_path.set_to_nearby_closest_offset(translation, 10.0)
		if (Input.is_action_just_pressed("auto_walk")):
			followed_path.set_to_closest_offset(global_transform.origin)
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
			if followed_path.disables_physics:
				$Body.disabled = true

		else:
			var spd = max_speed 
			if reverse_direction:
				spd = -spd
			followed_path.follower_offset += spd * delta
			var translation_diff = followed_path.get_vector_to_follower(global_transform.origin)
			translation_diff.normalized()
			translation_diff *= max_speed
			velocity = translation_diff
			if not followed_path.disables_physics:
				velocity.y += (gravity_mod + gravity) * delta
			velocity = move_and_slide(velocity, Vector3.UP, true)
			if followed_path.lock_player_direction:
				self.rotation.y = _get_angle_on_y_axis(followed_path.get_follower_global_origin())
	else:
		velocity.y += (gravity_mod + gravity) * delta
		$Body.disabled = false
		var desired_velocity = get_input() * max_speed

		velocity.x = desired_velocity.x
		velocity.z = desired_velocity.z
		velocity = move_and_slide(velocity, Vector3.UP, true)
	var walk_detection : Vector3 = velocity * Vector3(1, 0, 1)
	if walk_detection.length_squared() > JOGGING_VECTOR_MIN:
		$FootstepsAnimationPlayer.play("Jogging")
	elif walk_detection.length_squared() > FOOTSTEP_VECTOR_MIN:
		$FootstepsAnimationPlayer.play("Walking")

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

func _on_StandUpArea_body_entered(_body):
	stand_up_colliders += 1

func _on_StandUpArea_body_exited(_body):
	stand_up_colliders -= 1
	if stand_up_colliders < 0:
		stand_up_colliders = 0
