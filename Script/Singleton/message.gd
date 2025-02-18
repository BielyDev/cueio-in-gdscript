extends Node

enum TYPE_MESSAGE {
	PROFILE_REQUEST,
	PROFILE_RECEIVED,
	CHANGE_PROFILE_REQUEST,
	CHANGE_PROFILE_RECEIVED,
	NEW_ID,
	PLAYERS_RECEIVED,
}


func _ready() -> void:
	set_process(false)

func _process(_delta: float) -> void:
	filtering_packets_client()

func filtering_packets_client() -> void:
	var events = Host.Enet.service(64)
	
	match events[0]:
		ENetConnection.EVENT_RECEIVE:
			var message: Array = bytes_to_var(events[1].get_packet())
			received_message(message)

func received_message(message: Array) -> void:
	print(TYPE_MESSAGE.keys()[message[0]])
	match message[0]:
		TYPE_MESSAGE.PROFILE_REQUEST:
			Host.Enet.broadcast(0,var_to_bytes([TYPE_MESSAGE.PROFILE_RECEIVED,Host.my]),ENetPacketPeer.FLAG_RELIABLE)
			Host.Enet.flush()
		TYPE_MESSAGE.PLAYERS_RECEIVED:
			Host.players = message[1]
			reload_players()
		TYPE_MESSAGE.NEW_ID:
			Host.my.id = message[1] 
		TYPE_MESSAGE.PROFILE_RECEIVED:
			Host.players = message[1]
		TYPE_MESSAGE.CHANGE_PROFILE_RECEIVED:
			Host.players = message[1]
			reload_players()

func reload_players() -> void:
	Host.New_player_in_room.emit(Host.players)
