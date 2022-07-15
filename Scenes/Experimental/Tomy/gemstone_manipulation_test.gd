extends Control


func _ready():
	randomize()
	$BaseKaleidoscopeViewer.change_tumbler(preload("res://Scenes/Kaleidoscope/TumblerScenes/TumblerSceneBase.tscn"))


func create_gemstone_button():
	var gems = $BaseKaleidoscopeViewer.get_gemstones()
	var gem = gems[gems.size()-1]
	var btn = preload("res://Scenes/Experimental/Tomy/gemstone_button.tscn").instance()
	btn.gemstone = gem
	btn.connect("toggle_gemstone", self, "_on_toggle_gem_pressed")
	btn.connect("remove_gemstone", self, "_on_remove_gem_pressed")
	$CanvasLayer/GemList.add_child(btn)


func _on_TextureButton_pressed():
	$BaseKaleidoscopeViewer.add_gemstone(preload("res://Scenes/Kaleidoscope/Gemstones/DiamondGemstone.tscn"), Vector2(rand_range(-90, 90), rand_range(-90, 90)))
	create_gemstone_button()


func _on_TextureButton2_pressed():
	$BaseKaleidoscopeViewer.add_gemstone(preload("res://Scenes/Kaleidoscope/Gemstones/SquareGemstone.tscn"), Vector2(rand_range(-90, 90), rand_range(-90, 90)))
	create_gemstone_button()


func _on_TextureButton3_pressed():
	$BaseKaleidoscopeViewer.add_gemstone(preload("res://Scenes/Kaleidoscope/Gemstones/CircleGemstone.tscn"), Vector2(rand_range(-90, 90), rand_range(-90, 90)))
	create_gemstone_button()


func _on_toggle_gem_pressed(gem):
	$BaseKaleidoscopeViewer.toggle_gemstone(gem)

func _on_remove_gem_pressed(gem):
	$BaseKaleidoscopeViewer.remove_gemstone(gem)
