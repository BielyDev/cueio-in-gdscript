extends PathFollow3D

var player: PersonCharacter
var negative: bool

func _ready() -> void:
	player.lock_moviment()
	player.death_signal.connect(player_lock_death)

func _physics_process(delta: float) -> void:
	if negative:
		progress += -0.1
		
		if progress < 2:
			player_lock_death()
	else:
		progress += 0.1
		
		if progress > get_parent().curve.get_baked_length() - 2:
			player_lock_death()
	
	player.global_position = global_position + Vector3(0,-1.5,0)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("action"):
		player.lock_moviment(false)
		player.velocity = Vector3()
		queue_free()

func player_lock_death() -> void:
	player.lock_moviment(false)
	player.velocity = Vector3()
	queue_free()
