extends Control

const PERSON = preload("res://Scene/Player/person.tscn")

@onready var Servers: PanelContainer = $"."
@onready var Start: Button = $"../Buttons/Start"
@onready var Ready: Button = $"../Buttons/Ready"
@onready var Room: Button = $"../Buttons/Room"


func _ready() -> void:
	set_process(false)
	Host.Connect_is_room.connect(connect_is_room)
	Host.Change_my.connect(change_my)
	Host.connect_to_server()

func connect_is_room(players: Array) -> void:
	if Host.my.host == true:
		Start.show()
	else:
		Ready.show()
	Room.hide()

func _on_play_pressed() -> void:
	Host.inicialize_play()

func _on_room_pressed() -> void:
	#Host.connect_to_server()
	Servers.visible = !Servers.visible

func _on_ready_pressed() -> void:
	Host.my_ready()

func change_my() -> void:
	if Host.my.ready == true:
		Ready.modulate = Color.YELLOW
	else:
		Ready.modulate = Color.WHITE
