extends Control

@onready var vbox: VBoxContainer = $vbox

var players_kills: Dictionary = {}

@rpc("authority")
func update(id: int) -> void:
	
	players_kills[id] = Index.player.kill
	
	#sync_player_kills.rpc(players_kills)
	#update_list.rpc(id, kill)

@rpc("any_peer")
func sync_player_kills(value: Dictionary) -> void:
	
	players_kills = value
	update_list()

func update_list() -> void:
	for child in vbox.get_children():
		child.queue_free()
	
	for button in players_kills:
		var new_button = Button.new()
		
		new_button.disabled = true
		new_button.text = str(button," - ",players_kills.get(button))
		vbox.add_child(new_button)
