extends Marker3D

const PERSON = preload("res://Scene/Player/person.tscn")

@onready var pos_security: Node3D = $"../PosSecurity"

func _ready() -> void:
	Host.New_disconnection_in_room.connect(exit_player)
	
	for player in Host.players:
		var new_player = PERSON.instantiate()
		
		new_player.my = player
		add_child(new_player)

func exit_player(profile: Dictionary) -> void:
	for child in get_children():
		if child.my.id == profile.id:
			Index.player.Gui.Events.add_text(str("Player [color=yellow] ",profile.nickname," [/color] quitou!"))
			child.queue_free()

func distribue_position() -> Vector3:
	return pos_security.get_child(randi_range(0,pos_security.get_child_count()-1)).global_position
