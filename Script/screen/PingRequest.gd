extends Label

class_name PingRequest

var TimerRequest: Timer = Timer.new()

func _ready() -> void:
	add_child(TimerRequest)
