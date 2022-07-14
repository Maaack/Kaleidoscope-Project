extends HBoxContainer

signal toggle_gemstone(gemstone)
signal remove_gemstone(gemstone)

var gemstone


func _on_Button_pressed():
	emit_signal("toggle_gemstone", gemstone)


func _on_Button2_pressed():
	emit_signal("remove_gemstone", gemstone)
	queue_free()
