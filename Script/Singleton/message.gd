extends Node

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
}

enum PROFILE_MESSAGE {
	CONNECTION,
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
}


func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	filtering_packets_client()

func filtering_packets_client() -> void:
	var events = Host.Enet.service(1)
	
	match events[0]:
		ENetConnection.EVENT_RECEIVE:
			var message: Array = bytes_to_var(events[1].get_packet())
			received_message(message)

func received_message(message: Array) -> void:
	
	match message[0]:
		TYPE_MESSAGE.PROFILE_REQUEST:
			Host.Enet.broadcast(0,var_to_bytes([TYPE_MESSAGE.PROFILE_SEND,Host.my]),ENetPacketPeer.FLAG_RELIABLE)
			Host.Enet.flush()
		TYPE_MESSAGE.PLAYERS_RECEIVED:
			Host.players = message[1]
			reload_players()
		TYPE_MESSAGE.PROFILE_RECEIVED:
			match message[1]:
				PROFILE_MESSAGE.CONNECTION:
					Host.my = message[2]
					Host.players = message[3]
					reload_players()
					
					Host.Connect_is_room.emit(Host.players)
				PROFILE_MESSAGE.NEW_ID:
					Host.my.id = message[2]
			
		TYPE_MESSAGE.CHANGE_PROFILE_RECEIVED:
			Host.players = message[1]
			
			for player in Host.players:
				if player.id == Host.my.id:
					Host.my = player
			
			reload_players()
		TYPE_MESSAGE.PING:
			Host.Enet.broadcast(0,var_to_bytes([TYPE_MESSAGE.PONG,Host.my]),ENetPacketPeer.FLAG_RELIABLE)
			Host.Enet.flush()
		TYPE_MESSAGE.INCIALIZE_GAME_RECEIVED:
			match message[1]:
				ROOM_ERROR.OK:
					get_tree().change_scene_to_file("res://Scene/map/world.tscn")
				ROOM_ERROR.COUNT_ERROR:
					print("Precisa de mais players")
				ROOM_ERROR.READY_ERROR:
					print("Algum player não deu pronto")
		TYPE_MESSAGE.GAME:
			match message[1]:
				GAME.PLAYER_POSITION_UPDATE:
					Host.Player_position_update.emit(
						message[2], # ID
						message[3], # POSITION
						message[4], # CAM_ROTATION
						message[5], # BONE_ROTATION
						)
				GAME.PLAYER_STATE_MACHINE_UPDATE:
					Host.Player_state_machine_update.emit(
						message[2], # ID
						message[3], # DIRECTION
						message[4], # INPUT
						message[5], # IS_ON_FLOOR
						)
				GAME.PLAYER_EFFECT_BULLET:
					Host.Player_effect_bullet.emit(
						message[2], # ID
						message[3], # POINT COLLISION
						)
				GAME.PLAYER_SHOOT_DEMAGE:
					Host.Player_shoot_demage.emit(
						message[2], # ID
						message[3], # ENEMY_ID
						message[4], # DEMAGE
						message[5], # AREA_BODY
						)
				GAME.PLAYER_DEATH:
					Host.Player_death.emit(
						message[2], # ID
						message[3], # ENEMY_ID
						message[4], # AREA_BODY
						)


func reload_players() -> void:
	#print(Host.players)
	Host.New_player_in_room.emit(Host.players)
	Host.Change_my.emit()
