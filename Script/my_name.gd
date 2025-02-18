extends Label3D

func _ready() -> void:
	Host.Change_my.connect(update_nickname)

func update_nickname() -> void:
	send_nickname.rpc_id(1, Host.my.id, Host.my.nickname)

@rpc("authority")
func send_nickname(id: int, nickname: String) -> void:
	for player in multiplayer.get_peers():
		print(player)
		new_text.rpc_id(player, id, nickname)

@rpc("call_local")
func new_text(id: int, nickname: String) -> void:
	if get_parent().get_multiplayer_authority() == id:
		text = str(nickname)
