extends Button

class_name ButtonVisibled

@export var Node_selected: Control

func _pressed() -> void:
	Node_selected.visible = !Node_selected.visible
