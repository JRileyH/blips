extends Node2D
class_name Action

const font = preload("res://ui/font.tres")

var bloid: Node2D
var selected: bool = false
var dragging: bool = false
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

func start_drag():
	if dragging:
		return
	dragging = true

func stop_drag():
	if not dragging:
		return
	dragging = false
	var index = max(1, get_parent().get_index_from_angle(position.angle_to_point(Vector2.ZERO)))
	get_parent().move_action(self, index)
	

func reposition(idx: int, ang: float, pos: Vector2):
	index = idx
	angle = ang
	position = pos

func contains_point(point: Vector2) -> bool:
	return global_position.distance_to(point) < radius

func run() -> bool:
	return false

func to_string():
	return "None"

func _input(event):
	if dragging and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
		stop_drag()

func _process(delta):
	if dragging:
		global_position = get_global_mouse_position()

func _ready():
	bloid = get_parent().get_parent()

func _draw():
	draw_string(font, Vector2(50, 0), to_string())
	if selected:
		draw_circle(Vector2.ZERO, radius + 2, Color(0.45, 0.9, 0.5))
	draw_circle(Vector2.ZERO, radius, color)
