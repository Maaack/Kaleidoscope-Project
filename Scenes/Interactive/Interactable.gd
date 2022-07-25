tool
extends Spatial
class_name Interactable3D

enum InteractableType {
	NONE,
	RED,
	GREEN, 
	BLUE, 
	CYAN, 
	YELLOW, 
	PURPLE, 
	PINK, 
	MUSHROOM
}

enum InteractionMode {
	NONE,
	COLLISION_AREA,
	VISIBILITY_NOTIFIER
}

export(String) var interactable_text : String = ""
export(InteractableType) var interactable_type : int = InteractableType.NONE
export(InteractionMode) var interaction_mode : int = InteractionMode.NONE setget set_interaction_mode

var prior_interaction_mode : int = InteractionMode.NONE

func set_interaction_mode(value : int) -> void:
	interaction_mode = value
	var view_collision_shape = get_node_or_null("ViewColliderArea/CollisionShape")
	var visibility_notifier = get_node_or_null("VisibilityNotifier")
	if view_collision_shape == null:
		return
	match(interaction_mode):
		InteractionMode.NONE:
			view_collision_shape.disabled = true
			visibility_notifier.hide()
		InteractionMode.COLLISION_AREA:
			view_collision_shape.disabled = false
			visibility_notifier.hide()
		InteractionMode.VISIBILITY_NOTIFIER:
			view_collision_shape.disabled = true
			visibility_notifier.show()

func _ready():
	self.interaction_mode = interaction_mode

func interact() -> void:
	pass

func show() -> void:
	.show()
	self.interaction_mode = prior_interaction_mode

func hide() -> void:
	.hide()
	prior_interaction_mode = interaction_mode
	self.interaction_mode = InteractionMode.NONE

func _on_VisibilityNotifier_camera_entered(camera):
	if interaction_mode != InteractionMode.VISIBILITY_NOTIFIER:
		return
	if camera.has_method("enter_interactable"):
		camera.enter_interactable(self)

func _on_VisibilityNotifier_camera_exited(camera):
	if interaction_mode != InteractionMode.VISIBILITY_NOTIFIER:
		return
	if camera.has_method("exit_interactable"):
		camera.exit_interactable(self)
