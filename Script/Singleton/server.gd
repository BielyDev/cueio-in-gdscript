extends Node

var enet: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

var is_server: bool

func is_player(this: PersonCharacter) -> bool: #Verifica se o player é desse pc
	return this.get_multiplayer_authority() == Index.player.get_multiplayer_authority()

func create_server(ip: String, port: int) -> void:
	enet.create_server(port)
	multiplayer.multiplayer_peer = enet
	
	enet.peer_connected.connect(new_player_connected)
	enet.peer_disconnected.connect(new_player_disconnected)
	
	is_server = true

func connect_server(ip: String, port: int) -> void:
	enet.create_client(ip,port)
	multiplayer.multiplayer_peer = enet

func new_player_connected(id: int) -> void:
	print("New connect ",id)
func new_player_disconnected(id: int) -> void:
	print("Player disconnected ",id)
