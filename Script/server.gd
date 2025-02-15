extends Control

const PERSON = preload("res://Scene/Player/person.tscn")

@onready var server: Control = $"."
@onready var instance: Marker3D = $"../Instance"

var enet: ENetMultiplayerPeer = ENetMultiplayerPeer.new()


func _ready() -> void:
	set_process(false)
	
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)

func instance_player(id: int):
	var new_person = PERSON.instantiate()
	
	new_person.name = str(id)
	instance.add_child(new_person)

func _on_create_pressed() -> void:
	server.hide()
	enet.set_bind_ip("192.168.1.106")
	enet.create_server(1296)
	multiplayer.multiplayer_peer = enet
	multiplayer.peer_connected.connect(instance_player)
	instance_player(1)
func _on_join_pressed() -> void:
	server.hide()
	enet.create_client("192.168.1.106",1296)
	multiplayer.multiplayer_peer = enet

func peer_connected(id: int):
	print(id," connected")
func peer_disconnected(id: int):
	for child in instance.get_children():
		if child.name == str(id):
			child.queue_free()
