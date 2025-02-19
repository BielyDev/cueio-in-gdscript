extends PersonCharacter

const BULLET = preload("res://Scene/bullet.tscn")

@onready var point: Marker3D = $Camera/ViewPerson/View/CamPos/Model/person/metarig/Skeleton3D/Pivot/Shoot
@onready var nickname: Label3D = $nickname
@onready var position_timer: Timer = $Timers/position_timer

var is_player: bool = false

func _ready() -> void:
	nickname.text = str(my.nickname," - ",my.id)
	Model.get_active_material(0).set("shader_parameter/Color",my.color)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	set_physics_process(false)
	set_process_input(false)
	set_process(false)
	
	Host.Player_death.connect(verify_death)
	
	if Host.my.id == my.id:
		settings_player()
		
		set_process_input(true)
		set_physics_process(true)
		position_timer.start()
	else:
		set_process(true)
		Host.Player_position_update.connect(update_position)
		Host.Player_state_machine_update.connect(update_state_machine)

func _physics_process(delta: float) -> void:
	moviment()
	gravity()
	jump()
	aim_detected()
	State.apply_state(direction,Input.get_vector("left","right","down","up"),is_on_floor())
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

func effect_bullet(end_pos: Vector3) -> void:
	var new_bullet = BULLET.instantiate()
	
	State.shoot()
	Index.add_child(new_bullet)
	new_bullet.global_position = point.global_position
	new_bullet.pos_final = end_pos

var peer_transform = {
	"position" : Vector3(),
	"cam_rotation_y" : 0,
	"bone_rotation_x" : 0,
}

func update_position(id: int, _position: Vector3, cam_rotation_y: int,bone_rotation_x: int) -> void:
	if my.id == id:
		peer_transform.position = _position
		peer_transform.cam_rotation_y = cam_rotation_y
		peer_transform.bone_rotation_x = bone_rotation_x

func update_state_machine(id: int, _direction: Vector2, input: Vector2, is_floor: bool) -> void:
	if my.id == id:
		State.apply_state(_direction,input,is_floor)

func _process(delta: float) -> void:
	global_position = global_position.lerp(peer_transform.position, 8 * delta)
	CamPos.rotation.y = lerp_angle(CamPos.rotation.y,deg_to_rad(peer_transform.cam_rotation_y), 8 * delta)
	SpineBone.rotation.x = lerp_angle(SpineBone.rotation.x,deg_to_rad(peer_transform.bone_rotation_x), 8 * delta)


func _on_position_timeout() -> void:
	Host.player_moviment_update(global_position,CamPos.rotation_degrees.y,SpineBone.rotation_degrees.x)
	Host.player_state_machine(direction,Input.get_vector("left","right","down","up"),is_on_floor())


func verify_death(id: int, enemy_id: int, body_area: int) -> void:
	if id == my.id:
		death()
