extends Node3D

@onready var model: Node3D = $Point/Model

var players: int

func _ready() -> void:
	Server.enet.peer_connected.connect(new_player)
	Server.enet.peer_disconnected.connect(exit_player)

func new_player(id: int) -> void:
	players += 1
	
	var new_model = model.duplicate()
	
	new_model.name = str(id)
	get_child(players).add_child(new_model)

func exit_player(id: int) -> void:
	for child in get_children():
		if child.name.to_int() == id:
			child.queue_free()
