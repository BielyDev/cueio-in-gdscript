extends Node

signal Player_connected()
signal Player_disconnected(id: int)
signal Change_my(profile: Dictionary)

var Enet: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

var my: Dictionary = {
	"id" : 1,
	"nickname" : "my_name",
	"color" : Color.ANTIQUE_WHITE
}

var players: Array = []

func _ready() -> void:
	Enet.peer_connected.connect(new_connection)
	Enet.peer_disconnected.connect(new_disconnected)
	
	players.append(my)

func create_server(port: int) -> void:
	var err = Enet.create_server(port, 4)
	
	if err != OK:
		OS.alert("Erro ao criar sala!")
	
	multiplayer.multiplayer_peer = Enet

func connect_client(ip: String, port: int) -> void:
	var err = Enet.create_client(ip, port)
	
	if err != OK:
		OS.alert("Erro ao conectar-se!")
	
	multiplayer.multiplayer_peer = Enet
	my.id = multiplayer.multiplayer_peer.get_unique_id()
	
	await get_tree().create_timer(1).timeout
	send_server_message.rpc_id(1,my)

func new_connection(id: int) -> void:
	print(id)
func new_disconnected(id: int) -> void:
	print(id)

@rpc("any_peer","reliable")
func send_server_message(message) -> void:
	players.append(message)
	
	Player_connected.emit()
	send_client_message.rpc(players)

@rpc("authority","reliable")
func send_client_message(message) -> void:
	players = message
	
	Player_connected.emit()
