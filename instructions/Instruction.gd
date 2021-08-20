extends Selectable
class_name Instruction

func get_class(): return "Instruction"

var bloid: Selectable
var dragging: bool = false

func start_drag():
	if dragging:
		return
	dragging = true

"""
const ACTION_START = -3*PI/8
const ACTION_STEP = PI/8
func get_index_from_angle(angle: float):
	var i = 0
	var pointer = ACTION_START + (ACTION_STEP/2)
	while pointer < (PI*2) + ACTION_START:
		if angle < pointer:
			return i
		pointer += ACTION_STEP
		i += 1
	return i
"""

func stop_drag():
	if not dragging:
		return
	dragging = false
	#var idx = max(1, get_parent().get_index_from_angle(position.angle_to_point(Vector2.ZERO)))
	get_parent().move_action(self, 1)

func contains_point(point: Vector2) -> bool:
	return global_position.distance_to(point) < radius

func run() -> bool:
	return false

func to_string():
	return "None"

func _input(event):
	if dragging and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
		stop_drag()

func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position()

func _ready():
	add_to_group('instructions')
	bloid = get_parent().get_parent()

const font = preload("res://ui/font.tres")
func _draw():
	._draw()
	draw_set_transform(Vector2(0, 0), -rotation, Vector2(1, 1))
	draw_string(font, Vector2(60, 0), to_string())
	draw_set_transform(Vector2(0, 0), 0, Vector2(1, 1))
