extends Node3D

const MODEL = preload("res://Scene/Player/model.tscn")

func _ready() -> void:
	Host.New_player_in_room.connect(add_player)
	
	load_players(Host.players)
	#Host..connect(remove_player)
	pass
	#load_players()

func add_player(players: Array) -> void:
	load_players(players)
func remove_player(players: Array) -> void:
	load_players(players)

func load_players(players: Array) -> void:
	
	for child in get_children():
		for model in child.get_children():
			model.queue_free()
	
	for player_number in players.size():
		instance_player(get_child(player_number),players[player_number])

func instance_player(parent: Node3D, profile: Dictionary) -> void:
	var new_model = MODEL.instantiate()
	
	parent.add_child(new_model)
	
	Index.player = new_model
	new_model.set_multiplayer_authority(profile.id)
	new_model.get_node("my_name").text = profile.nickname
	new_model.get_node("person/metarig/Skeleton3D/Model").update_color(profile.color)
