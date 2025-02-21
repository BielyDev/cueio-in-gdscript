extends Node3D

const MODEL = preload("res://Scene/Player/model.tscn")

func _ready() -> void:
	load_players(Host.players)
	
	Host.New_player_in_room.connect(load_players)
	Host.New_disconnection_in_room.connect(remove_player)


func add_player(profile: Dictionary) -> void:
	for child in get_children():
		if child.get_child_count() == 0:
			instance_player(child,profile)

func remove_player(profile: Dictionary) -> void:
	for child in get_children():
		for model in child.get_children():
			if model.name.to_int() == profile.id:
				model.queue_free()

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
