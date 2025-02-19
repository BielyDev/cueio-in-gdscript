extends Marker3D

const PERSON = preload("res://Scene/Player/person.tscn")

@onready var pos_security: Node3D = $"../PosSecurity"

func _ready() -> void:
	for player in Host.players:
		var new_player = PERSON.instantiate()
		
		new_player.my = player
		add_child(new_player)

func distribue_position() -> Vector3:
	return pos_security.get_child(randi_range(0,pos_security.get_child_count()-1)).global_position
