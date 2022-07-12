extends Node


func _on_KaleidoscopeControl_player_rotated(rotation):
	$KaleidoscopeViewport.next_rotation = rotation


func _on_KaleidoscopeControl_player_double_clicked():
	pass
