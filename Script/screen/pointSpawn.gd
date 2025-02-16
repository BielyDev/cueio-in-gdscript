extends Node3D

const MODEL = preload("res://Scene/Player/model.tscn")

var players: int

func _ready() -> void:
	new_player(Host.my)
	
	#Server.Peer_connected.connect(new_player)
	#Server.Peer_disconnected.connect(exit_player)
	Server.Change_players.connect(reload_players)

func reload_players(_players: Array) -> void:
	players = 0
	
	for child in get_children():
		for new_model in child.get_children():
			new_model.queue_free()
	
	for player in _players:
		new_player(player)

func new_player(player: Dictionary) -> void:
	var new_model = MODEL.instantiate()
	
	new_model.name = str(player.id)
	get_child(players).add_child(new_model)
	
	new_model.get_node("my_name").text = str(player.nickname)
	players += 1

func exit_player(id: int) -> void:
	for child in get_children():
		if child.name.to_int() == id:
			child.queue_free()
