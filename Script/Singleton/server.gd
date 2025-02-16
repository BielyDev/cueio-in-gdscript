extends Node

signal Connected_in_server()
signal Peer_connected(_id: int)
signal Peer_disconnected(_id: int)
signal Change_players(_players: Array)


enum TYPE {
	#DEFINE_ID,
	CONNECTION_SERVER,
	NEW_CONNECTION,
	PROFILE_SEND,
	PROFILE_NEW,
	PROFILE_CHANGE,
	PROFILE_RECEIVED,
	INFO_PLAYERS_REQUEST,
	INFO_PLAYERS_RECEIVED
}

#var enetPacket: ENetPacketPeer

var is_server: bool
var players: Array = []




func received_packet(peer, packet: Array) -> void:
	print("Pacote: ",packet)
	match packet[0]: #TYPE
		##[codeblock]
		##TYPE.DEFINE_ID: # Quando o id do noia for definido pelo servidor
		##	my.id = packet[1]
		##	Host.set_id(my.id)
		##	
		##	Peer_connected.emit(my.id)
		##	
		##	sendServer(my, TYPE.PROFILE_SEND)
		##[/codeblock]
		TYPE.CONNECTION_SERVER:
			Peer_connected.emit(Host.get_multiplayer_authority())
			
			sendProfille(Host.my, TYPE.PROFILE_NEW)
		TYPE.PROFILE_SEND:
			match packet[1]:
				TYPE.PROFILE_NEW:
					players.append(packet[2])
				TYPE.PROFILE_CHANGE:
					for player in players:
						if player.id == packet[2].id:
							players.erase(player)
							players.append(packet[2])
			
			sendAll(players, TYPE.PROFILE_RECEIVED)
			Change_players.emit(players)
			
		TYPE.PROFILE_RECEIVED:
			players = packet[1]
			
			Change_players.emit(players)
		
		TYPE.NEW_CONNECTION: # Nova conexão :P
			print("connection")



func sendPlayer(_PeerPacker: ENetPacketPeer,_mensage, _type_packet: int = 0, _flag: int = ENetPacketPeer.FLAG_RELIABLE) -> void:
	_PeerPacker.send(0,var_to_bytes([_type_packet,_mensage]),_flag)

func sendServer(_mensage, _type_packet: int = 0, _flag: int = ENetPacketPeer.FLAG_RELIABLE) -> void:
	Host.enetMultiplayer.host.broadcast(0,var_to_bytes([_type_packet,_mensage]),_flag)
	Host.enetMultiplayer.host.flush()

func sendAll(_mensage, _type_packet: int = 0, _flag: int = ENetPacketPeer.FLAG_RELIABLE) -> void:
	for player: ENetPacketPeer in Host.enetMultiplayer.host.get_peers():
		player.send(0,var_to_bytes([_type_packet,_mensage]),_flag)

func sendProfille(_mensage,  _type_profile_packet: int = 0, _flag: int = ENetPacketPeer.FLAG_RELIABLE) -> void:
	for player: ENetPacketPeer in Host.enetMultiplayer.host.get_peers():
		player.send(0,var_to_bytes([TYPE.PROFILE_SEND,_type_profile_packet,_mensage]),_flag)

func new_player_connected(id: int) -> void:
	print("New connect ",id)
func new_player_disconnected(id: int) -> void:
	print("Player disconnected ",id)
