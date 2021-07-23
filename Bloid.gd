extends Node2D
class_name Bloid

export (float) var radius = 40.0
export(Color) var color = Color(0.6, 0.6, 0.6)

signal selected

var blips: Array = []
var neighbors: Array = []

func add_blip(blip: Node2D):
	if not blip:
		return
	if not blip in blips:
		blips.append(blip)

func remove_blip(blip: Node2D):
	if not blip:
		return
	if blip in blips:
		blips.erase(blip)

func add_neighbor(neighbor: Bloid):
	if not neighbor:
		return
	if not neighbor in neighbors:
		neighbors.append(neighbor)

func remove_neighbor(neighbor: Bloid):
	if not neighbor:
		return
	if neighbor in neighbors:
		neighbors.erase(neighbor)

func distance_to(other: Bloid) -> float:
	return global_position.distance_to(other.global_position)

func set_color(c: Color = Color(0.6, 0.6, 0.6)):
	color = c
	update()

func _input(event):
	var distance = get_local_mouse_position().distance_to(Vector2.ZERO)
	if distance < radius and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		yield(get_tree(), "physics_frame")
		emit_signal("selected", self)

func _draw():
	draw_circle(Vector2.ZERO, radius, color)
