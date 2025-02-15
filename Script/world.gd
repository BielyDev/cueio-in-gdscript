extends Node3D

const PERSON = preload("res://Scene/Player/person.tscn")

@onready var Instance: Marker3D = $Instance

func _ready() -> void:
	OS.request_permissions()
	
	Server.enet.peer_connected.connect(instance_player)
	Server.enet.peer_disconnected.connect(free_player)
	
	if Server.is_server:
		instance_player(1)

func instance_player(id: int):
	var new_person = PERSON.instantiate()
	
	new_person.name = str(id)
	Instance.add_child(new_person)

func free_player(id: int):
	
	for child: PersonCharacter in Instance.get_children():
		if child.get_multiplayer_authority() == id:
			child.queue_free()
