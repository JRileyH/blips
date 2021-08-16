extends Action
class_name AddAction

const RADIUS: float = 30.0
const OPTION_RADIUS: float = 8.0

class AddOption:
	var _pos: Vector2
	var _color: Color
	var _type
	
	func _init(color: Color, type):
		_color = color
		_type = type

var options: Array = []

func _ready():
	color = Color(0.5, 0.6, 0.65)
	options.append(AddOption.new(Color(0.7, 0.45, 0.55), MoveAction))
	options.append(AddOption.new(Color(0.2, 0.85, 0.35), StandByAction))
	options.append(AddOption.new(Color(0.1, 0.45, 0.95), UpgradeAction))
	reposition(index, angle, position)

func reposition(idx: int, ang: float, pos: Vector2):
	.reposition(idx, ang, pos)
	options[0]._pos = Vector2(cos(ang - PI/5) * RADIUS, sin(ang - PI/5) * RADIUS)
	options[1]._pos = Vector2(cos(ang) * RADIUS, sin(ang) * RADIUS)
	options[2]._pos = Vector2(cos(ang + PI/5) * RADIUS, sin(ang + PI/5) * RADIUS)

func _option_contains_point(point: Vector2) -> bool:
	for option in options:
		if to_global(option._pos).distance_to(point) < OPTION_RADIUS:
			return true
	return false

func contains_point(point: Vector2) -> bool:
	return .contains_point(point) or _option_contains_point(point)

func _input(event):
	if selected and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		for option in options:
			if option._pos.distance_to(get_local_mouse_position()) < OPTION_RADIUS:
				var new_action = option._type.new()
				get_parent().add_action(new_action)
				yield(get_tree(), "physics_frame")
				get_parent().select_action(new_action)

func _draw():
	if selected:
		for option in options:
			draw_circle(option._pos, OPTION_RADIUS, option._color)
	draw_circle(Vector2.ZERO, radius, color)
