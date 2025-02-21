extends Marker3D

@export var count: int = 1
@export var timer: float = 0.1

const SHOOT: Array = [preload("res://Assets/2D/Effects/shoot_0.png"),preload("res://Assets/2D/Effects/shoot_1.png")]


func _ready() -> void:
	for i in count:
		var new_shoot = ShootFire.new()
		
		new_shoot.texture = SHOOT[randi_range(0,1)]
		add_child(new_shoot)
		await get_tree().create_timer(timer).timeout
