extends Marker3D

var sensi: float = 0.15

@onready var person: CharacterBody3D = $"../../../.."
@onready var bone: BoneAttachment3D = $Model/person/metarig/Skeleton3D/Bone

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		rotation.y += -deg_to_rad(event.relative.x * sensi)
		bone.rotation.x += deg_to_rad(event.relative.y * sensi)
		
		bone.rotation_degrees.x = clamp(bone.rotation_degrees.x,-70,70)
