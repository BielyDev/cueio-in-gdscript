extends Control

@onready var nickname: Button = $nickname


func _on_name_text_changed(new_text: String) -> void:
	Host.my.nickname = new_text
	nickname.text = new_text
	
	Host.Change_my.emit()


func _on_color_color_changed(color: Color) -> void:
	Host.my.color = color
	Host.Change_my.emit()
