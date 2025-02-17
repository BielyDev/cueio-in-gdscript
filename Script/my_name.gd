extends Label3D

func _ready() -> void:
	Host.Change_my.connect(update_nickname)

func update_nickname() -> void:
	new_text.rpc(Host.my.id, Host.my.nickname)

@rpc("any_peer","call_local","reliable")
func new_text(id: int, nickname: String) -> void:
	if get_parent().get_multiplayer_authority() == id:
		text = str(nickname)
