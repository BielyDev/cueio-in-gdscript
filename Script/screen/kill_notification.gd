extends Control

@export var text: PackedStringArray
@export var icon: Array[Texture]

@onready var Texture_node: TextureRect = $vbox/texture
@onready var Label_node: Label = $vbox/label
@onready var Anima: AnimationPlayer = $Anima

func start(type: int) -> void:
	Label_node.text = text[type]
	Texture_node.texture = icon[type]
	
	Anima.stop()
	Anima.play("start")
