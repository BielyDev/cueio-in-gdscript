extends Path3D

@export var length: int = 10

@onready var pos: Node3D = $"../../Pos"

func _ready() -> void:
	curve.clear_points()

func _process(delta: float) -> void:
	if curve.point_count > length:
		curve.remove_point(0)
	else:
		curve.add_point(pos.global_position)
