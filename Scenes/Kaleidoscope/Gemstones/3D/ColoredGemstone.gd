tool
extends RigidBody


export(Color) var color : Color = Color(1,0,0,0.5) setget set_color

func set_color (value : Color) -> void:
	color = value
	if color == null:
		return
	var material : SpatialMaterial = $MeshInstance.get_surface_material(0)
	material = material.duplicate()
	material.albedo_color = color
	$MeshInstance.set_surface_material(0, material)
