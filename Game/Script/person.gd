extends CharacterBody3D

class_name PersonCharacter

signal death_signal

enum TYPE_KILL {SUICIDE,COMMON,HEADSHOT}

const LIFE = preload("res://Scene/effect/life.tscn")

const SPEED: float = 4.0
const JUMP: float = 7.0
const GRAVITY: float = 0.3
const MAX_GRAVITY: float = 25.0

var direction: Vector2
var is_move: bool = true
var my_colors: Color = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1))
var kill: int

var my: Dictionary

var life: int = 100:
	set(value):
		value = clamp(value,0,100)
		
		life = value
		
		if is_instance_valid(LifeProgress):
			LifeProgress.get_child(0).text = str(life)
			LifeProgress.value = value

@export var CamPos: Marker3D
@export var CamPerson: Camera3D
@export var CamWorld: Camera3D
@export var Shoot: RayCast3D
@export var Model: MeshInstance3D
@export var View: MeshInstance3D
@export var Skeleton: Skeleton3D
@export var SpineBone: BoneAttachment3D
@export var SpinePosition: Node3D
@export var Gui: CanvasLayer
@export var State: Node
@export var Gun: Node

@export var LifeProgress: TextureProgressBar:
	set(value):
		LifeProgress = value
		
		LifeProgress.value = life

func moviment() -> void:
	if !is_move: return
	
	direction = Vector2.ZERO
	
	direction.y += CamPos.global_basis.z.z * Input.get_axis("up","down")
	direction.x += CamPos.global_basis.z.x * Input.get_axis("up","down")
	direction.x += CamPos.global_basis.z.z * Input.get_axis("left","right")
	direction.y += -CamPos.global_basis.z.x * Input.get_axis("left","right")
	
	if is_on_floor():
		direction = direction.normalized() * SPEED
	else:
		direction = direction.normalized() * (SPEED * 0.7)
	
	velocity.x = lerp(velocity.x, direction.x, 0.1)
	velocity.z = lerp(velocity.z, direction.y, 0.1)

func gravity() -> void:
	velocity.y += -GRAVITY
	
	if velocity.y < -MAX_GRAVITY:
		velocity.y = -MAX_GRAVITY

func jump() -> void:
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP

func death() -> void:
	death_signal.emit()
	
	settings_death(false)
	await get_tree().create_timer(3).timeout
	settings_death(true)
	
	var new_life = LIFE.instantiate()
	Index.add_child(new_life)
	new_life.global_position = global_position
	
	global_position = get_parent().distribue_position()
	
	life = 100
	SpineBone.position = Vector3(0,1.4,0.06)
	SpineBone.rotation_degrees = Vector3(16.5,0,0)

func settings_death(value: bool = false) -> void:
	SpineBone.override_pose = value
	
	$AreaDemage/Body/CollisionShape3D.disabled = !value
	$AreaDemage/Head/CollisionShape3D.disabled = !value
	
	if value == false:
		Skeleton.get_node("Physics").physical_bones_start_simulation()
	else:
		Skeleton.get_node("Physics").physical_bones_stop_simulation()
	
	if my.id == Host.my.id:
		set_process_input(value)
		set_physics_process(value)
		CamPos.set_process_input(value)
		State.AnimaTree.active = value

func settings_player() -> void:
	Model.show()
	View.hide()
	
	Index.player = self
	
	$Camera/ViewWorld.show()
	$Camera/ViewPerson.show()
	
	global_position = get_parent().distribue_position()
	
	for child in Gun.get_children():
		child.set_layers()
		child.set_layers()
	
	CamPerson.current = true
	CamWorld.current = true
	
	SpinePosition.position = Vector3(0.235,-0.410,0.343)
	
	var gui = preload("res://Scene/Player/gui.tscn").instantiate()
	add_child(gui)
	
	Gui = gui
	LifeProgress = gui.LifeProgress

func new_kill(_death: int,_type: int) -> void:
	kill += 1
	
	if is_multiplayer_authority():
		Gui.KillNotification.start(_type)

func add_life(amount: int) -> void:
	life += amount

func load_visual() -> void:
	Model.get_active_material(0).set("shader_parameter/Color", my_colors)

func aim_detected() -> void:
	if Shoot.is_colliding() and Shoot.get_collider() is Area3D:
		Gui.Aim.detected(true)
	else:
		Gui.Aim.detected(false)

func lock_moviment(value: bool = true) -> void:
	is_move = !value
