extends Control

@onready var nickname: Button = $nickname
@onready var color: ColorPickerButton = $Profile/Panel/Margin/vbox/Color
@onready var name_edit: LineEdit = $Profile/Panel/Margin/vbox/name



func _on_x_pressed() -> void:
	Host.my.nickname = name_edit.text
	nickname.text = name_edit.text
	Host.my.color = color.color
	
	Host.Change_my.emit()
