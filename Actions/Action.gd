extends Node2D
class_name Action

var selected: bool = false
var radius = 15.0
var color = Color(1.0, 1.0, 1.0)
var index: int = 0
var angle: float = 0

func select():
	selected = true
	update()

func deselect():
	selected = false
	update()

func reposition(idx: int, ang: float, pos: Vector2):
	index = idx
	angle = ang
	position = pos

func contains_point(point: Vector2) -> bool:
	return global_position.distance_to(point) < radius

func _draw():
	if selected:
		draw_circle(Vector2.ZERO, radius + 2, Color(0.45, 0.9, 0.5))
	draw_circle(Vector2.ZERO, radius, color)
