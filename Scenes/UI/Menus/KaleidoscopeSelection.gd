extends Control

signal tumbler_selected(tumbler)


# connect all buttons
func _ready():
	for k_btn in get_tree().get_nodes_in_group("KaleidoscopeButtons"):
		k_btn.connect("tumbler_selected", self, "_on_tumbler_selected")


# transmit the signal from the button
func _on_tumbler_selected(tumbler):
	emit_signal("tumbler_selected", tumbler)
