extends BaseKaleidoscopeViewer


var stage : int = 0

func _advance_level():
	stage += 1
	var match_node = get_node("MarginContainer/Control2/Match%d" % stage)
	if match_node == null:
		return
	match_node.show()

func _on_KaleidoscopeControl_player_double_clicked():
	_advance_level()

func _ready():
	_advance_level()
