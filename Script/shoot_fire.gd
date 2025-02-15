extends Sprite3D

class_name ShootFire

func _ready() -> void:
	scale = Vector3(0.06,0.06,0.06)
	
	rotation_degrees.z = randi_range(0,360)	
	create_tween().tween_property(self,"scale",Vector3(0.1,0.1,0.1),0.1)
	await create_tween().tween_property(self,"modulate:a",0,0.1).finished
	
	queue_free()
