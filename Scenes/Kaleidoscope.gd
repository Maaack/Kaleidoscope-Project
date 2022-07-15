extends ViewportContainer


func _ready():
	pass # Replace with function body.



func _process(delta):
	if Input.is_action_just_pressed("toggle_show_kaleidoscope",true):
		var enabled = material.get_shader_param("enabled")
		material.set_shader_param("enabled", !enabled)
