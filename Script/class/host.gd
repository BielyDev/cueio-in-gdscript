extends Node

signal Connect_is_room(players: Array)
signal New_player_in_room(players: Array)
signal New_disconnection_in_room(player: Dictionary)
signal Change_my()

signal Player_position_update(id: int, position: Vector3, cam_rotation_y: int, bone_rotation_x: int)
signal Player_state_machine_update(id: int, direction: Vector2, input: Vector2, is_floor: bool)
signal Player_effect_bullet(id: int, position_point: Vector3)
signal Player_shoot_demage(id: int, enemy_id: int, demage_id: int, body_area: int)
signal Player_death(id: int, enemy_id: int, body_area: int)
signal Player_change_gun(id: int, gun_id: int)

var Enet: ENetConnection = ENetConnection.new()

var my: Dictionary = {
	"id" : 0,
	"nickname" : "my_name",
	"color" : Color(1, 0.71, 0.6),
	"host" : false,
	"ready" : false,
}
var players: Array

func _init() -> void:
	players.append(my)

func is_player(id: int) -> bool:
	for player in players:
		if id == player.id:
			return true
	return false

func connect_to_server(ip: String = "127.0.0.1",port: int = 8000) -> bool:
	var create_host_err: int = Enet.create_host()
	if create_host_err != OK:
		OS.alert("Falha ao criar host")
		
		return false
	
	var connect_server: ENetPacketPeer = Enet.connect_to_host(ip, port)
	if connect_server == null:
		OS.alert("Falha ao conectar-se no servidor")
		
		return false
	
	MessageServer.set_physics_process(true)
	return true

func change_profile() -> void:
	Enet.broadcast(0,var_to_bytes([MessageServer.TYPE_MESSAGE.CHANGE_PROFILE_REQUEST,my]), ENetPacketPeer.FLAG_RELIABLE)
	Enet.flush()

func inicialize_play() -> void:
	Enet.broadcast(0,var_to_bytes([MessageServer.TYPE_MESSAGE.INICIALIZE_GAME_REQUEST,my]),ENetPacketPeer.FLAG_RELIABLE)
	Enet.flush()

func my_ready() -> void:
	Enet.broadcast(0,var_to_bytes([MessageServer.TYPE_MESSAGE.INICIALIZE_GAME_REQUEST,my]),ENetPacketPeer.FLAG_RELIABLE)
	Enet.flush()

func player_moviment_update(position: Vector3,cam_rotation_y: int,bone_rotation_x: int) -> void:
	Enet.broadcast(2,var_to_bytes([MessageServer.TYPE_MESSAGE.GAME,MessageServer.GAME.PLAYER_POSITION_UPDATE,
	my.id,
	position,
	cam_rotation_y,
	bone_rotation_x
	]),ENetPacketPeer.FLAG_UNRELIABLE_FRAGMENT)
	Enet.flush()

func player_state_machine(direction: Vector2, input: Vector2, is_floor: bool) -> void:
	Enet.broadcast(3,var_to_bytes([MessageServer.TYPE_MESSAGE.GAME,MessageServer.GAME.PLAYER_STATE_MACHINE_UPDATE,
	my.id,
	direction,
	input,
	is_floor
	]),ENetPacketPeer.FLAG_UNRELIABLE_FRAGMENT)
	Enet.flush()


func player_effect_bullet(pos_point: Vector3) -> void:
	Enet.broadcast(4,var_to_bytes([MessageServer.TYPE_MESSAGE.GAME,MessageServer.GAME.PLAYER_EFFECT_BULLET,
	my.id,
	pos_point,
	]),ENetPacketPeer.FLAG_UNRELIABLE_FRAGMENT)
	Enet.flush()

func player_shoot_demage(enemy_id: int, demage_id: int, body_area: int) -> void:
	Enet.broadcast(4,var_to_bytes([MessageServer.TYPE_MESSAGE.GAME,MessageServer.GAME.PLAYER_SHOOT_DEMAGE,
	my.id,
	enemy_id,
	demage_id,
	body_area
	]),ENetPacketPeer.FLAG_UNRELIABLE_FRAGMENT)
	Enet.flush()

func player_death_confirm(enemy_id: int, area_body: int) -> void:
	Enet.broadcast(4,var_to_bytes([MessageServer.TYPE_MESSAGE.GAME,MessageServer.GAME.PLAYER_DEATH,
	my.id,
	enemy_id,
	area_body,
	]),ENetPacketPeer.FLAG_UNRELIABLE_FRAGMENT)
	Enet.flush()

func player_change_gun(gun_use: int) -> void:
	Enet.broadcast(5,var_to_bytes([MessageServer.TYPE_MESSAGE.GAME,MessageServer.GAME.PLAYER_CHANGE_GUN,
	my.id,
	gun_use,
	]),ENetPacketPeer.FLAG_UNRELIABLE_FRAGMENT)
	Enet.flush()
