extends Node

signal new_connection(profile: Dictionary)
signal new_disconnection(id: int)
signal change_profile(profile: Dictionary)
signal new_error(events: Array)
signal new_events(id: int)

@onready var exit_player: Timer = $exit_player

var Enet: ENetConnection = ENetConnection.new()

enum TYPE_MESSAGE {
	PROFILE_REQUEST,
	PROFILE_SEND,
	PROFILE_RECEIVED,
	CHANGE_PROFILE_REQUEST,
	CHANGE_PROFILE_RECEIVED,
	PLAYERS_RECEIVED,
	PING,
	PONG,
	INICIALIZE_GAME_REQUEST,
	INCIALIZE_GAME_RECEIVED,
	GAME,
	HOST,
}
enum PROFILE_MESSAGE {
	CONNECTION,
	DISCONNECTION,
	NEW_ID,
}
enum ROOM_ERROR {
	OK,
	COUNT_ERROR,
	READY_ERROR,
}
enum GAME {
	PLAYER_POSITION_UPDATE,
	SHOOT,
	HIT_CONFIRMATION,
	PLAYER_STATE_MACHINE_UPDATE,
	PLAYER_EFFECT_BULLET,
	PLAYER_SHOOT_DEMAGE,
	PLAYER_DEATH,
	PLAYER_CHANGE_GUN,
}
enum HOST {
	CREATE,
	ENTER,
	DELETE,
	READY,
	INICIALIZE,
}


var players: Array = []
var host: Array = []
var save_pong: Array = []

func _ready() -> void:
	set_process(false)
	new_room()

func _process(delta: float) -> void:
	filtering_packets_server()

func new_room(ip: String = "127.0.0.1", port: int = 8000) -> bool:
	var err: int = Enet.create_host_bound(ip, port, 32, 10)
	if err != OK:
		OS.alert("Deu tudo errado irmão")
		return false
	
	set_process(true)
	return true

func filtering_packets_server() -> void:
	var events = Enet.service(0.1)
	var packet: ENetPacketPeer = events[1]
	
	match events[0]:
		ENetConnection.EVENT_RECEIVE:
			
			received_message(packet)
		ENetConnection.EVENT_CONNECT:
			var client: ENetPacketPeer = events[1]
			
			client.send(0,var_to_bytes([TYPE_MESSAGE.PROFILE_REQUEST]),0)
		ENetConnection.EVENT_DISCONNECT:
			send_all_players([TYPE_MESSAGE.PING])
			
			exit_player.start(0)
		ENetConnection.EVENT_ERROR:
			new_error.emit(events)

func received_message(packet: ENetPacketPeer) -> void:
	var message: Array = bytes_to_var(packet.get_packet())
	new_events.emit(message[0])
	match message[0]:
		TYPE_MESSAGE.PROFILE_SEND:
			var profile: Dictionary = message[1]
			
			if profile.id == 0:
				profile.id = randi_range(0,9999)
			
			if players.size() == 0:
				profile.host = true
				profile.ready = true
			
			add_player(profile)
			
			packet.send(0,var_to_bytes([TYPE_MESSAGE.PROFILE_RECEIVED,PROFILE_MESSAGE.CONNECTION,profile,players]),ENetPacketPeer.FLAG_RELIABLE)
			
			send_all_players([TYPE_MESSAGE.PLAYERS_RECEIVED,players])
			
			new_connection.emit(profile)
		TYPE_MESSAGE.CHANGE_PROFILE_REQUEST:
			add_player(message[1])
			change_profile.emit(message[1])
			
			send_all_players([TYPE_MESSAGE.CHANGE_PROFILE_RECEIVED,players])
		TYPE_MESSAGE.PONG:
			save_pong.append(message[1])
		TYPE_MESSAGE.INICIALIZE_GAME_REQUEST:
			if message[1].host == true:
				if players.size() < 2:
					packet.send(0,var_to_bytes([TYPE_MESSAGE.INCIALIZE_GAME_RECEIVED,ROOM_ERROR.COUNT_ERROR]),ENetPacketPeer.FLAG_RELIABLE)
					return
				for player in players:
					if player.ready == false:
						packet.send(0,var_to_bytes([TYPE_MESSAGE.INCIALIZE_GAME_RECEIVED,ROOM_ERROR.READY_ERROR]),ENetPacketPeer.FLAG_RELIABLE)
						return
				
				send_all_players([TYPE_MESSAGE.INCIALIZE_GAME_RECEIVED,ROOM_ERROR.OK])
			else:
				message[1].ready = !message[1].ready
				
				add_player(message[1])
				
				send_all_players([TYPE_MESSAGE.CHANGE_PROFILE_RECEIVED,players])
		TYPE_MESSAGE.GAME:
			receveid_game(packet ,message)

func receveid_game(packet: ENetPacketPeer ,message: Array) -> void:
	match message[1]:
		GAME.PLAYER_POSITION_UPDATE:
			send_all_players_excluse([
				TYPE_MESSAGE.GAME,
				GAME.PLAYER_POSITION_UPDATE,
				message[2], # ID
				message[3], # POSITION
				message[4], # CAM_ROTATION
				message[5], # BONE_ROTATION
				],packet,2,ENetPacketPeer.FLAG_UNRELIABLE_FRAGMENT)
		GAME.PLAYER_STATE_MACHINE_UPDATE:
			send_all_players_excluse([
				TYPE_MESSAGE.GAME,
				GAME.PLAYER_STATE_MACHINE_UPDATE,
				message[2], # ID
				message[3], # DIRECTION
				message[4], # INPUT
				message[5], # IS_ON_FLOOR
				],packet,3,ENetPacketPeer.FLAG_UNRELIABLE_FRAGMENT)
		GAME.PLAYER_EFFECT_BULLET:
			send_all_players_excluse([
				TYPE_MESSAGE.GAME,
				GAME.PLAYER_EFFECT_BULLET,
				message[2], # ID
				message[3], # POINT COLLISION
				],packet,4,ENetPacketPeer.FLAG_UNRELIABLE_FRAGMENT)
		GAME.PLAYER_SHOOT_DEMAGE:
			send_all_players([
				TYPE_MESSAGE.GAME,
				GAME.PLAYER_SHOOT_DEMAGE,
				message[2], # ID
				message[3], # ENEMY_ID
				message[4], # DEMAGE_ID
				message[5], # BODY_AREA
				],4,ENetPacketPeer.FLAG_RELIABLE)
		GAME.PLAYER_DEATH:
			send_all_players([
				TYPE_MESSAGE.GAME,
				GAME.PLAYER_DEATH,
				message[2], # ID
				message[3], # ENEMY_ID
				message[4], # BODY_AREA
				],4,ENetPacketPeer.FLAG_RELIABLE)
		GAME.PLAYER_CHANGE_GUN:
			send_all_players_excluse([
				TYPE_MESSAGE.GAME,
				GAME.PLAYER_CHANGE_GUN,
				message[2], # ID
				message[3], # GUN ID
				],packet,5,ENetPacketPeer.FLAG_UNRELIABLE_FRAGMENT)



func send_all_players(message: Array,channel: int = 0,flag: int = ENetPacketPeer.FLAG_RELIABLE) -> void:
	for peer in Enet.get_peers():
		peer.send(channel,var_to_bytes(message),flag)

func send_all_players_excluse(message: Array,packet: ENetPacketPeer,channel: int = 0,flag: int = ENetPacketPeer.FLAG_RELIABLE) -> void:
	for peer in Enet.get_peers():
		if peer != packet:
			peer.send(channel,var_to_bytes(message),flag)

func add_player(profile: Dictionary) -> void:
	for player in players:
		if player.id == profile.id:
			players.erase(player)
			players.append(profile)
			return
	
	players.append(profile)


func _exit_player_timeout() -> void:
	var exit_players: Array
	var redefined_host: bool
	
	for player in players:
		var exit: bool = true
		for save in save_pong:
			if save == player:
				exit = false
		if exit:
			exit_players.append(player)
	
	for exit in exit_players:
		new_disconnection.emit(exit.id)
		players.erase(exit)
		
		if exit.host == true:
			redefined_host = true
	
	if redefined_host:
		call_redefined_host()
	
	send_all_players([TYPE_MESSAGE.PROFILE_RECEIVED,PROFILE_MESSAGE.DISCONNECTION,exit_players])
	save_pong = []

func call_redefined_host() -> void:
	for player in players:
		player.host = true
		return
