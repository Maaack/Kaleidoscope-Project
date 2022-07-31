class_name FollowedPath
extends Path

onready var path_follower = $PathFollow
onready var path_follower_spatial = $PathFollow/Spatial

export(bool) var bidirectional : bool = false
export(bool) onready var looping : bool = true setget set_looping
export(float) onready var follower_offset : float = 0.0 setget set_follower_offset

func set_looping(value : bool) -> void:
	looping = value
	if looping == null or path_follower == null:
		return
	path_follower.loop = looping

func set_follower_offset(value : float) -> void:
	follower_offset = value
	if follower_offset == null or path_follower == null:
		return
	path_follower.offset = follower_offset

func get_closest_offset(to_origin : Vector3) -> float:
	return get_curve().get_closest_offset(to_origin)

func set_to_closest_offset(to_origin : Vector3) -> void:
	self.follower_offset = get_closest_offset(to_origin)

func set_to_nearby_closest_offset(to_origin : Vector3, max_range : float) -> void:
	var closest_offset : float = get_closest_offset(to_origin)
	var diff : float =  abs(follower_offset - closest_offset)
	print("%f - %f, %f > %f = %s" % [follower_offset, closest_offset, diff, max_range, (diff > max_range)])
	if diff > max_range:
		return
	self.follower_offset = closest_offset

func get_follower_global_origin() -> Vector3:
	return path_follower_spatial.global_transform.origin

func get_start_point_position() -> Vector3:
	return get_curve().get_point_position(0)

func get_end_point_position() -> Vector3:
	return get_curve().get_point_position(get_curve().get_point_count()-1)