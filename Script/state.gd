extends Node

@onready var Person: PersonCharacter = get_parent()

@export var AnimaTree: AnimationTree

func _ready() -> void:
	AnimaTree.set("parameters/state/transition_request","pistol")

func apply_state(dir: Vector2,dir_input: Vector2,floor: bool) -> void:
	
	AnimaTree.set("parameters/move/walk_pos/blend_position",dir_input)
	AnimaTree.set("parameters/move_arm/walk_pos/blend_position",dir_input)
	AnimaTree.set("parameters/move_arm/state/blend_amount",AnimaTree.get("parameters/move/state/blend_amount"))
	
	if floor:
		var is_move: bool = dir.x != 0 or dir.y != 0
		
		AnimaTree.set("parameters/move/state/blend_amount",(float(is_move)-0.5) * 2)
	else:
		AnimaTree.set("parameters/move/state/blend_amount",0)

func shoot() -> void:
	AnimaTree.set("parameters/pistol_state/transition_request","shoot")
