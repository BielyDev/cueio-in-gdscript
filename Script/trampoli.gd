extends Node3D

@onready var Anima: AnimationPlayer = $Animation

func _on_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.velocity.y = 20
		
		Anima.stop()
		Anima.play("start")
