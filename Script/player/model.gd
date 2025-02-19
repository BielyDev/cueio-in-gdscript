extends MeshInstance3D

func update_color(color: Color) -> void:
	get_active_material(0).set("shader_parameter/Color",color)
