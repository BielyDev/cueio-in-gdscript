extends Marker3D

@onready var pos_security: Node3D = $"../PosSecurity"

func _ready() -> void:
	Index.all_players = self

func distribue_position() -> Vector3:
	return pos_security.get_child(randi_range(0,pos_security.get_child_count()-1)).global_position
