extends Node3D

@onready var Person: CharacterBody3D = $".."
@onready var AreaDemage: Node3D = $"../AreaDemage"

var await_shoot: Timer = Timer.new()
var guns: Array = [Index.get_gun(2),Index.get_gun(1),Index.get_gun(0)]
var gun_use: int = 1:
	set(value):
		gun_use = value
		
		for child in get_children():
			child.queue_free()
		
		add_child(load(guns[gun_use].path).instantiate())
		
		await_shoot.wait_time = guns[gun_use].time
		Person.Shoot.target_position = Vector3(0,0,-guns[gun_use].distance)

func _ready() -> void:
	Host.Player_effect_bullet.connect(received_shoot_effect)
	Host.Player_shoot_demage.connect(received_shoot_demage)
	
	gun_use = 1
	
	Index.add_child(await_shoot)
	await_shoot.one_shot = true

func get_gun() -> Dictionary:
	return guns[gun_use]

func bullet() -> void:
	if Input.is_action_just_pressed("shoot") and await_shoot.is_stopped():
		await_shoot.start()
		Person.Gui.Aim.shoot()
		
		if Person.Shoot.is_colliding():
			Person.effect_bullet(Person.Shoot.get_collision_point())
			Host.player_effect_bullet(Person.Shoot.get_collision_point())
			
			if Person.Shoot.get_collider().is_in_group("player"):
				
				var AD: Node3D = Person.Shoot.get_collider().get_parent()
				
				if Person.Shoot.get_collider().name == "Head":
					Host.player_shoot_demage(AD.get_parent().my.id, get_gun().head_demage, PersonCharacter.TYPE_KILL.HEADSHOT)
				elif Person.Shoot.get_collider().name == "Body":
					Host.player_shoot_demage(AD.get_parent().my.id, get_gun().demage, PersonCharacter.TYPE_KILL.COMMON)
			else:
				Index.effect.bullet_destroyer.rpc(Person.Shoot.get_collision_point(),Person.Shoot.get_collision_normal())
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

func input_change_gun() -> void:
	if Input.is_action_just_pressed("gun_one"):
		gun_use = 0
	if Input.is_action_just_pressed("gun_two"):
		gun_use = 1
	if Input.is_action_just_pressed("gun_three"):
		gun_use = 2
