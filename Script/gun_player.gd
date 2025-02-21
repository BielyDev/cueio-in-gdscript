extends Node3D

@onready var Person: CharacterBody3D = $".."
@onready var AreaDemage: Node3D = $"../AreaDemage"
@onready var State: Node = $"../State"
@onready var Shoot: RayCast3D = $"../Camera/ViewPerson/View/CamPos/Cam/Shoot"

var await_shoot: Timer = Timer.new()
var guns: Array = [Index.get_gun(2),Index.get_gun(1),Index.get_gun(0)]
var gun_use: int = 1:
	set(value):
		gun_use = value
		
		for child in get_children():
			child.queue_free()
		
		var gun = load(guns[gun_use].path).instantiate()
		
		add_child(gun)
		
		if Person.my.id == Host.my.id:
			gun.set_layers()
			Host.player_change_gun(gun_use)
		
		State.change_gun(guns[gun_use].animation)
		await_shoot.wait_time = guns[gun_use].time
		Person.Shoot.target_position = Vector3(0,0,-guns[gun_use].distance)

func _ready() -> void:
	Host.Player_effect_bullet.connect(received_shoot_effect)
	Host.Player_shoot_demage.connect(received_shoot_demage)
	Host.Player_change_gun.connect(received_change_gun)
	
	gun_use = 1
	
	Index.add_child(await_shoot)
	await_shoot.one_shot = true

func get_gun() -> Dictionary:
	return guns[gun_use]

func bullet() -> void:
	if await_shoot.is_stopped():
		if get_gun().one_shoot:
			if Input.is_action_just_pressed("shoot"):
				shoot()
		else:
			if Input.is_action_pressed("shoot"):
				shoot()

func _process(delta: float) -> void:
	Shoot.rotation_degrees = Shoot.rotation_degrees.lerp(Vector3(),get_gun().spread)

func shoot() -> void:
	Shoot.rotation_degrees = Shoot.rotation_degrees + Vector3(randf_range(-3,3),randf_range(-3,3),randf_range(-3,3))
	
	await_shoot.start()
	Person.Gui.Aim.shoot()
	
	if Person.Shoot.is_colliding():
		Person.effect_bullet(Person.Shoot.get_collision_point())
		Host.player_effect_bullet(Person.Shoot.get_collision_point())
		
		if Person.Shoot.get_collider().is_in_group("player"):
			
			var AD: Node3D = Person.Shoot.get_collider().get_parent()
			Person.Gui.Aim.demage()
			
			if Person.Shoot.get_collider().name == "Head":
				Host.player_shoot_demage(AD.get_parent().my.id, get_gun().head_demage, PersonCharacter.TYPE_KILL.HEADSHOT)
			elif Person.Shoot.get_collider().name == "Body":
				Host.player_shoot_demage(AD.get_parent().my.id, get_gun().demage, PersonCharacter.TYPE_KILL.COMMON)
		else:
			Host.player_effect_bullet(Person.Shoot.to_global(Vector3(0,0,-get_gun().distance)))
			Index.effect.bullet_destroyer(Person.Shoot.get_collision_point(),Person.Shoot.get_collision_normal())
	else:
		Host.player_effect_bullet(Person.Shoot.to_global(Vector3(0,0,-get_gun().distance)))
		Person.effect_bullet(Person.Shoot.to_global(Vector3(0,0,-get_gun().distance)))

func received_shoot_effect(id: int, pos: Vector3) -> void:
	if id == Person.my.id:
		Person.effect_bullet(pos)
func received_shoot_demage(id: int, enemy_id: int, demage: int, area_body: int) -> void:
	
	if enemy_id == Person.my.id:
		Person.life -= demage
		
		if Person.my.id == Host.my.id:
			if Person.life < 1:
				Host.player_death_confirm(id, area_body)
func received_change_gun(id: int, gun_id: int) -> void:
	if Person.my.id == id:
		gun_use = gun_id

func input_change_gun() -> void:
	if Input.is_action_just_pressed("gun_one"):
		gun_use = 0
	if Input.is_action_just_pressed("gun_two"):
		gun_use = 1
	if Input.is_action_just_pressed("gun_three"):
		gun_use = 2
