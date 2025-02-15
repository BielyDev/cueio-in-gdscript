extends Node3D

@onready var Person: CharacterBody3D = $".."

@rpc("any_peer")
func receive_demage(id: int,demage: int,shoot_type: int) -> void:
	Person.life -= demage
	
	if get_parent().life < 1:
		Person.rpc_id(
			id,
			"new_kill",
			get_parent().get_multiplayer_authority(),
			shoot_type
		)
		
		Person.Gui.ListKill.update.rpc(get_multiplayer_authority())
	
