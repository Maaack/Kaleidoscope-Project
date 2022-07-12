class_name BaseKaleidoscopeViewer
extends Node


func _on_KaleidoscopeControl_player_rotated(rotation):
	$KaleidoscopeViewport.next_rotation = rotation

