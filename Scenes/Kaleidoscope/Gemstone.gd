tool
extends RigidBody2D


export(Texture) var sprite_texture : Texture setget set_sprite_texture

func set_sprite_texture(value : Texture) -> void:
	sprite_texture = value
	if sprite_texture == null:
		return
	$Sprite.texture = sprite_texture
