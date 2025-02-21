extends Node3D

@onready var collision_shape_3d: CollisionShape3D = $Area/CollisionShape3D
@onready var anima: AnimationPlayer = $Anima

func _on_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and body.my.id == Host.my.id:
		if body.life != 100:
			body.add_life(50)
			#Host.player_
			
			collision_shape_3d.disabled = true
			anima.play("finished")


func _on_anima_animation_finished(anim_name: StringName) -> void:
	if anim_name == "finished":
		queue_free()


func _on_free_timeout() -> void:
	collision_shape_3d.disabled = true
	anima.play("finished")
