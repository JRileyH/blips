extends Action
class_name UpgradeAction

const RADIUS: float = 30.0
const OPTION_RADIUS: float = 8.0
class AddOption:
	var _pos: Vector2
	var _color: Color
	var _stat: int
	
	func _init(color: Color, stat: int):
		_color = color
		_stat = stat

var options: Array = []

const ACTION_TYPE="UPGRADE"

var until: int = -1
var stat: int = -1

func run():
	if until < 0 or stat < 0:
		# Values have not yet been set for this action
		print("Skipping upgrade because uninitialized")
		return false
	if bloid.stats[stat] >= 100: # TODO: Make dynamic? Bloid.MAX_STAT_VALUE(stat):
		# bloid is at max stat
		print("Skipping upgrade because max stat")
		return false
	if bloid.stats[stat] >= until:
		# action limit is fulfilled
		print("Skipping upgrade because limit fulfilled")
		return false
	if bloid.blips.size() == 0:
		# No blips to perform action
		print("Skipping upgrade because no blips")
		return false
	bloid.update_stat(stat)
	print("Upgrading")
	return true

func reposition(idx: int, ang: float, pos: Vector2):
	.reposition(idx, ang, pos)
	for i in range(4):
		options[i]._pos = Vector2(cos(ang) * (RADIUS + (i * RADIUS)) , sin(ang) * (RADIUS + (i * RADIUS)))

func _option_contains_point(point: Vector2) -> bool:
	for option in options:
		if to_global(option._pos).distance_to(point) < OPTION_RADIUS:
			return true
	return false

func contains_point(point: Vector2) -> bool:
	return .contains_point(point) or _option_contains_point(point)

func get_stat_name(stat: int):
	match stat:
		bloid.STAT.VISIBILITY:
			return "Visibility"
		bloid.STAT.PRODUCTION:
			return "Production"
		bloid.STAT.EFFICIENCY:
			return "Efficiency"
		bloid.STAT.CAPACITY:
			return "Capacity"
	return "Nothing"

func to_string():
	return "Upgrade %s until %s" % [get_stat_name(stat), until]

func _input(event):
	if selected and event is InputEventKey and event.pressed:
		var input = OS.get_scancode_string(event.scancode)
		if input == "BackSpace":
			until = -1
			update()
		elif input.is_valid_integer():
			if until <= 0:
				until = int(input)
			else:
				until = int("%s%s" % [until, input])
			update()
	if selected and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		for option in options:
			if option._pos.distance_to(get_local_mouse_position()) < OPTION_RADIUS:
				color = option._color
				stat = option._stat
				update()

func _ready():
	color = Color(0.1, 0.45, 0.95)
	options.append(AddOption.new(Color(0.8, 0.9, 0.1), bloid.STAT.VISIBILITY))
	options.append(AddOption.new(Color(0.3, 0.9, 0.1), bloid.STAT.PRODUCTION))
	options.append(AddOption.new(Color(0.8, 0.2, 0.7), bloid.STAT.CAPACITY))
	options.append(AddOption.new(Color(0.3, 0.9, 0.9), bloid.STAT.EFFICIENCY))
	reposition(index, angle, position)

func _draw():
	._draw()
	if selected:
		for option in options:
			draw_circle(option._pos, OPTION_RADIUS, option._color)
