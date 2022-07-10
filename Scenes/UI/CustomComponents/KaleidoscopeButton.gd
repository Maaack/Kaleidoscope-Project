extends Button


export(PackedScene) var kaleidoscope_viewport : PackedScene
export var viewport_visible = false setget set_kaleidoscope_visible

# Called when the node enters the scene tree for the first time.
func _ready():
	if kaleidoscope_viewport and kaleidoscope_viewport.can_instance():
		var instance : KaleidoscopeViewport = kaleidoscope_viewport.instance()
		instance.name = "KaleidoscopeViewport"
		instance.visible = viewport_visible
		add_child(instance)


func set_kaleidoscope_visible(value : bool):
	var viewport = get_node_or_null("KaleidoscopeViewport")
	if viewport:
		viewport.visible = value
