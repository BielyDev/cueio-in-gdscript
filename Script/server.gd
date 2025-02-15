extends Control

const PERSON = preload("res://Scene/Player/person.tscn")

func _ready() -> void:
	set_process(false)

func _on_create_pressed() -> void:
	Server.create_server("192.168.1.106",9999)
	
	#get_tree().change_scene_to_file("res://Scene/map/world.tscn")
func _on_join_pressed() -> void:
	Server.connect_server("192.168.1.106",9999)
	
	
	#get_tree().change_scene_to_file("res://Scene/map/world.tscn")
