extends Node3D

func set_layers(this: Node3D = self) -> void:
	for child in this.get_children():
		if child is MeshInstance3D:
			child.set_layer_mask_value(1,false)
			child.set_layer_mask_value(2,true)
		else:
			set_layers(child)
