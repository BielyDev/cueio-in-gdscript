extends Node3D

@onready var Person: CharacterBody3D = $".."

func receive_demage() -> void:
	
	if get_parent().life < 1:
		Person.Gui.ListKill.update.rpc(get_multiplayer_authority())
	
