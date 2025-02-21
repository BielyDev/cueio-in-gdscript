extends CanvasLayer

@onready var Server: Node = $".."

@onready var Playerlist: VBoxContainer = $Interface/vbox/hbox/PanelPlayers/Scroll/list
@onready var Errorlist: VBoxContainer = $Interface/vbox/hbox/PanelError/Scroll/list
@onready var Eventslist: VBoxContainer = $Interface/vbox/PanelEvents/Scroll/list

func _on_server_new_connection(profile: Dictionary) -> void:
	var player_info = Button.new()
	var color_info = ColorRect.new()
	
	Playerlist.add_child(player_info)
	player_info.add_child(color_info)
	
	player_info.name = str(profile.id)
	player_info.text = str(profile.nickname," - ",profile.host,"-",profile.id)
	player_info.alignment = HORIZONTAL_ALIGNMENT_LEFT
	
	color_info.size = Vector2(25,25)
	color_info.position.x = 250
	color_info.position.y = 4
	color_info.color = profile.color

func _on_server_new_disconnection(id: int) -> void:
	for child in Playerlist.get_children():
		if child.name.to_int() == id:
			child.queue_free()
			return

func _on_server_change_profile(profile: Dictionary) -> void:
	for child in Playerlist.get_children():
		if child.name.to_int() == profile.id:
			child.text = str(profile.nickname," - ",profile.id)
			child.get_child(0).color = profile.color

func _on_server_new_error(events: Array) -> void:
	var error_info = Button.new()
	
	error_info.text = str(events)
	error_info.alignment = HORIZONTAL_ALIGNMENT_LEFT
	Errorlist.add_child(error_info)

func _on_server_new_events(id: int) -> void:
	var error_info = Button.new()
	
	error_info.text = str(Server.TYPE_MESSAGE.keys()[id]," - ",Time.get_time_dict_from_system())
	error_info.alignment = HORIZONTAL_ALIGNMENT_LEFT
	
	Eventslist.add_child(error_info)
	
	if Eventslist.get_child_count() > 50:
		Eventslist.get_child(0).queue_free()
