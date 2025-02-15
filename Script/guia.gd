extends Node3D

const POINT_GUIA = preload("res://Scene/resource/pointGuia.tscn")

@onready var Path: Path3D = $Path
@onready var Casts: Node3D = $Casts
@onready var lock_player: PathFollow3D = $Path/LockPlayer

var area: Area3D = Area3D.new()

func _ready() -> void:
	set_process(false)
	
	add_child(area)
	area.set_collision_layer_value(1,false)
	area.set_collision_mask_value(1,false)
	area.set_collision_mask_value(8,true)
	
	area.monitorable = false
	area.body_entered.connect(active_process)
	area.body_exited.connect(desative_process)
	
	for cast: CastGuia in Casts.get_children():
		var collision: CollisionShape3D = CollisionShape3D.new()
		
		collision.shape = cast.shape
		area.add_child(collision)
		collision.global_position = cast.global_position
		collision.global_rotation = cast.global_rotation

func active_process(body: Node) -> void:
	if body.is_in_group("player"):
		set_process(true)
func desative_process(body: Node) -> void:
	if body.is_in_group("player"):
		set_process(false)

func _process(delta: float) -> void:
	for cast in Casts.get_children():
		if cast.is_colliding():
			for collider in cast.get_collision_count():
				
				if cast.get_collider(collider).is_multiplayer_authority():
					cast.get_node("Action").show()
					
					if Input.is_action_just_pressed("action"):
						action(cast.get_collider(collider), cast.negative)
		else:
			cast.get_node("Action").hide()

func action(person: PersonCharacter, negative: bool) -> void:
	var new_point = POINT_GUIA.instantiate()
	
	new_point.negative = negative
	new_point.player = person
	Path.add_child(new_point)
