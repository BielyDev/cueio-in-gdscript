extends PersonCharacter

const BULLET = preload("res://Scene/bullet.tscn")

@onready var point: Marker3D = $Camera/ViewPerson/View/CamPos/Model/person/metarig/Skeleton3D/Pivot/Shoot

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	set_physics_process(false)
	set_process_input(false)
	
	if is_multiplayer_authority():
		settings_player()
		
		set_process_input(true)
		set_physics_process(true)

func _physics_process(delta: float) -> void:
	moviment()
	gravity()
	jump()
	aim_detected()
	State.apply_state.rpc(direction,Input.get_vector("left","right","down","up"),is_on_floor())
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Gun.bullet()
		Gun.input_change_gun()
	
	if Input.is_action_just_pressed("pause"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		elif Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)




@rpc("call_local")
func effect_bullet(end_pos: Vector3) -> void:
	var new_bullet = BULLET.instantiate()
	
	State.shoot()
	Index.add_child(new_bullet)
	new_bullet.global_position = point.global_position
	new_bullet.pos_final = end_pos
