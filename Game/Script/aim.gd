extends Marker2D

var tw_scale_point: Tween = create_tween()
var tw_scale: Tween = create_tween()
var tw_color: Tween = create_tween()

@onready var Point: Node2D = $Point

func shoot() -> void:
	tw_scale.stop()
	
	scale = Vector2(2,2)
	tw_scale = create_tween()
	tw_scale.tween_property(self,"scale",Vector2(0.7,0.7),0.5)

func demage() -> void:
	tw_scale_point.stop()
	
	Point.modulate.a = 1
	tw_scale_point = create_tween()
	tw_scale_point.tween_property(Point,"modulate:a",0,0.5)

func detected(value: bool) -> void:
	tw_color.stop()
	
	tw_color = create_tween()
	
	if value:
		tw_color.tween_property(self,"modulate",Color.RED,0.1)
	else:
		tw_color.tween_property(self,"modulate",Color.WHITE,0.1)
