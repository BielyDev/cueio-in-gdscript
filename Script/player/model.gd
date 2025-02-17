extends MeshInstance3D

func _ready() -> void:
	Host.Change_my.connect(call_update)

func call_update() -> void:
	update_color.rpc(Host.my.id, Host.my.color)

@rpc("any_peer","call_local","reliable")
func update_color(id: int, color: Color) -> void:
	if $"../../../..".get_multiplayer_authority() == id:
		get_active_material(0).set("shader_parameter/Color",color)
