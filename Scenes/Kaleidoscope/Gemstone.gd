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
	var collisionShape : Node2D = get_node_or_null("CollisionShape2D")
	if collisionShape == null:
		collisionShape = get_node_or_null("CollisionPolygon2D")
	if collisionShape != null:
		collisionShape.disabled = !enabled

func _on_Gemstone_body_entered(body):
	$CollisionAkEvent2D.post_event()
