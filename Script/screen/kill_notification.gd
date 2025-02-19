extends Control

@export var text: PackedStringArray
@export var icon: Array[Texture]

@onready var Texture_node: TextureRect = $vbox/texture
@onready var Label_node: Label = $vbox/label
@onready var Anima: AnimationPlayer = $Anima

func _ready() -> void:
	Host.Player_death.connect(call_start)

func call_start(id: int, enemy_id: int, body_area: int) -> void:
	start(body_area)

func start(type: int) -> void:
	Label_node.text = text[type]
	Texture_node.texture = icon[type]
	
	Anima.stop()
	Anima.play("start")
