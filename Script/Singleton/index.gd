extends Node

const PATH_GUN = "res://Assets/JSON/guns.json"

var player: Node3D
var all_players: Node3D
var effect = Effect.new()

func _ready() -> void:
	add_child(effect)

func get_gun(id: int):
	var all_guns = JSON.parse_string(FileAccess.open(PATH_GUN,FileAccess.READ).get_as_text())
	
	for gun in all_guns:
		if all_guns.get(gun).id == id:
			return all_guns.get(gun)
