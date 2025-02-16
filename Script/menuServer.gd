extends Control

const PERSON = preload("res://Scene/Player/person.tscn")

@onready var Servers: PanelContainer = $"."

func _ready() -> void:
	set_process(false)

func _on_create_pressed() -> void:
	Host.create_server("127.0.0.1",8080)
	Servers.hide()
	#get_tree().change_scene_to_file("res://Scene/map/world.tscn")
func _on_join_pressed() -> void:
	Host.connect_server("127.0.0.1",8080)
	
	#get_tree().change_scene_to_file("res://Scene/map/world.tscn")
