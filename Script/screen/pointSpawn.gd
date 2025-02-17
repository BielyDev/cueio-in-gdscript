extends Node3D

const MODEL = preload("res://Scene/Player/model.tscn")

func _ready() -> void:
	Host.Player_connected.connect(add_player)
	Host.Player_disconnected.connect(remove_player)
	
	load_players()

func add_player() -> void:
	load_players()
func remove_player() -> void:
	load_players()

func load_players() -> void:
	await get_tree().create_timer(1).timeout
	
	for child in get_children():
		for model in child.get_children():
			model.queue_free()
	
	for player_number in Host.players.size():
		instance_player(get_child(player_number),Host.players[player_number])

func instance_player(parent: Node3D, profile: Dictionary) -> void:
	var new_model = MODEL.instantiate()
	
	parent.add_child(new_model)
	
	Index.player = new_model
	new_model.set_multiplayer_authority(profile.id)
	new_model.get_node("my_name").text = profile.nickname
