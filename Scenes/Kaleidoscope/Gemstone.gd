tool
extends RigidBody2D


export(Texture) var sprite_texture : Texture setget set_sprite_texture

var enabled = true setget set_enabled


func set_sprite_texture(value : Texture) -> void:
	sprite_texture = value
	if sprite_texture == null:
		return
	$Sprite.texture = sprite_texture


func set_enabled(value : bool) -> void:
	enabled = value
	$Sprite.visible = enabled
	if $CollisionShape2D != null:
		$CollisionShape2D.disabled = !enabled
	if $CollisionPolygon2D != null:
		$CollisionPolygon2D.disabled = !enabled
	
