extends Marker3D

const SPEED: int = 2

@onready var pos: Node3D = $Pos
@onready var line: CSGPolygon3D = $Off/Line
@onready var path: Path3D = $Off/Path

var pos_final: Vector3:
	set(value):
		pos_final = value
		
		if value != Vector3():
			look_at(pos_final)
			set_physics_process(true)


func _ready() -> void:
	set_physics_process(false)
	create_tween().tween_property(line.material,"shader_parameter/Color",Color(1,1,1,0),0.3)

func _physics_process(delta: float) -> void:
	if path.curve.point_count > 0:
		pos.transform.origin.z += -SPEED
	
	if pos.global_position.distance_to(pos_final) < 0.4:
		finished()

func finished() -> void:
	set_physics_process(false)
	path.set_process(false)
	pos.hide()
	
	await get_tree().create_timer(1).timeout
	queue_free()
func _on_timer_timeout() -> void:
	finished()
