extends Node

signal Connect_is_room(players: Array)
signal New_player_in_room(players: Array)
signal Change_my()

var Enet: ENetConnection = ENetConnection.new()

var my: Dictionary = {
	"id" : 0,
	"nickname" : "my_name",
	"color" : Color(1,1,1),
}
var players: Array

func connect_to_server(ip: String = "127.0.0.1",port: int = 8000) -> bool:
	var create_host_err: int = Enet.create_host()
	if create_host_err != OK:
		OS.alert("Falha ao criar host")
		
		return false
	
	var connect_server: ENetPacketPeer = Enet.connect_to_host(ip, port)
	if connect_server == null:
		OS.alert("Falha ao conectar-se no servidor")
		
		return false
	
	MessageServer.set_process(true)
	return true
