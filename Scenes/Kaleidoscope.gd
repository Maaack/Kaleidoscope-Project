extends ViewportContainer


func _ready():
	material.set_shader_param("enabled", false)



func _process(delta):
	if Input.is_action_just_pressed("toggle_show_kaleidoscope",true):
		var enabled = material.get_shader_param("enabled")
		material.set_shader_param("enabled", !enabled)


func _on_Dreamscape_mushroom_eated():
	material.set_shader_param("enabled", true)
