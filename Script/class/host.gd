extends Node

signal Change_my(_my: Dictionary)

var enetMultiplayer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

var my: Dictionary = {
	id = 1,
	nickname = "My_nickname",
	color = Color.DARK_SALMON
}:
	set(value):
		my = value
		Change_my.emit(value)


func set_id(id: int) -> void:
	set_multiplayer_authority(id)


func create_server(ip: String, port: int) -> bool:
	enetMultiplayer.set_bind_ip(ip)
	
	var err = enetMultiplayer.create_server(port,5)
	
	if err != OK:
		OS.alert(str("Erro ao criar o servidor: ", err),"Server")
		return false
	
	#var new_host = Host.enetMultiplayer.host.create_host_bound(ip, port,5)
	#print(new_host)
	
	OS.alert(str("Servidor criado no IP: ", ip, " na porta: ", port),"Server")
	
	multiplayer.multiplayer_peer = enetMultiplayer
	Host.set_multiplayer_authority(1)
	
	Server.is_server = true
	Server.players.append(my)
	
	set_process(true)
	return true
func connect_server(ip: String, port: int) -> bool:
	var err = enetMultiplayer.create_client(ip, port)
	if err != OK:
		OS.alert(str("Erro ao criar host no cliente: ", err),"Server")
		return false
	
	var connect = enetMultiplayer.host.connect_to_host(ip,port)
	print(connect)
	OS.alert(str("Conectado ao servidor em ", ip, ":", port),"Server")
	
	multiplayer.multiplayer_peer = enetMultiplayer
	#Host.set_multiplayer_authority(self)
	print(enetMultiplayer.get_unique_id())
	set_multiplayer_authority(enetMultiplayer.get_unique_id())
	set_process(true)
	return true



func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	received_service()

func received_service() -> void:
	var events = Host.enetMultiplayer.host.service(64)
	
	for event in events:
		match event:
			ENetConnection.EVENT_CONNECT:
				var EnetPacked: ENetPacketPeer = events[1]
				
				if Server.is_server:
					Server.sendPlayer(EnetPacked, Server.TYPE.CONNECTION_SERVER)
					#Peer_connected.emit(generate_id)
				#else:
					#Connected_in_server.emit()
				
			ENetConnection.EVENT_DISCONNECT:
				print("Conexão perdida")
				
			ENetConnection.EVENT_RECEIVE:
				var packet = bytes_to_var(events[1].get_packet())
				print("Events -  ",events)
				Server.received_packet(events[1],packet)
				#received
				
				print(Server.TYPE.keys()[packet[0]]," ",packet[1])
			ENetConnection.EVENT_ERROR:
				print("Erro ao receber pacote")
			ENetConnection.EVENT_NONE:
				pass
				#Quando nada é enviado
