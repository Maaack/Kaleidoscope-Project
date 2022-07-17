extends Node2D



func _on_UI_tumbler_selected(tumbler):
	$BaseKaleidoscopeViewer/KaleidoscopeViewport.change_tumbler(tumbler)
