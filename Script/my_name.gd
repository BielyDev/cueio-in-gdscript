extends Label3D

func _ready() -> void:
	Host.Change_my.connect(update_nickname)

func update_nickname(my: Dictionary) -> void:
	new_text.rpc(my.nickname)
	#get_tree().get_multiplayer().set_mu

@rpc("authority")
func new_text(nickname: StringName) -> void:
	text = nickname
