extends Node

class_name Effect

const SPAWN_SHOOT_FIRE = preload("res://Scene/effect/spawn_shoot_fire.tscn")
const BULLET_DESTROYER = preload("res://Scene/effect/bullet_destroyer.tscn")

static func spawn_shoot_fire(pos: Vector3, count: int = 2) -> void:
	var new_spawn = SPAWN_SHOOT_FIRE.instantiate()
	
	new_spawn.timer = 0.05
	new_spawn.count = count
	Index.add_child(new_spawn)
	
	new_spawn.global_position = pos

@rpc("any_peer","call_local")
static func bullet_destroyer(pos: Vector3, normal: Vector3 = Vector3()) -> void:
	var new_destroyer = BULLET_DESTROYER.instantiate()
	
	Index.add_child(new_destroyer)
	
	new_destroyer.global_position = pos
	new_destroyer.look_at(Index.player.global_position)
	
	await Index.get_tree().create_timer(1).timeout
	new_destroyer.queue_free()
