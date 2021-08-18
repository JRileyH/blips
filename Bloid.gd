extends Node2D
class_name Bloid

var Blip = preload("res://Blip.tscn")

export (float) var radius = 40.0
export(Color) var color = Color(0.3, 0.4, 0.4)

signal selected
signal deselected

signal action_selected
signal action_deselected

var production_timer: float = 0.0
var action_timer: float = 0.0

var blips: Array = []
var neighbors: Array = []

var active: bool = false
var selected: bool = false

var map: Node2D

static func MAX_STAT_VALUE(stat: int) -> int:
	match stat:
		STAT.VISIBILITY:
			return 100
		STAT.PRODUCTION:
			return 100
		STAT.CAPACITY:
			return 100
		STAT.EFFICIENCY:
			return 100
	return -1

enum STAT {
	VISIBILITY,
	PRODUCTION,
	CAPACITY,
	EFFICIENCY
}
var stats: Dictionary = {
	STAT.VISIBILITY: 1,
	STAT.PRODUCTION: 10,
	STAT.CAPACITY: 10,
	STAT.EFFICIENCY: 10
}

func activate():
	active = true
	$Actions.add_action(
		AddAction.new()
	)

func update_stat(stat: int):
	if not stats.has(stat):
		push_error("%s stat not valid" % [stat])
		return
	stats[stat] += 1
	if stat == STAT.VISIBILITY:
		map.reveal_bloid(self, 64 + (stats[STAT.VISIBILITY] * 2))
	consume_blip()

func add_blip(blip: Node2D = null):
	if not blip:
		blip = Blip.instance()
	add_child(blip)
	blip.linear_velocity = 100.0
	blip.attach(self)
	blips.append(blip)

func remove_blip(blip: Node2D = null):
	if blips.size() == 0:
		return
	if not blip or not blip in blips:
		blip = blips[0]
	blips.erase(blip)

func consume_blip(blip: Node2D = null):
	if blips.size() == 0:
		return
	if not blip or not blip in blips:
		blip = blips[0]
	blip.consume()

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

func select():
	selected = true
	emit_signal("selected", self)
	$Actions.visible = true
	update()

func deselect():
	selected = false
	emit_signal("deselected", self)
	$Actions.visible = false
	update()

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		var action = $Actions.get_action_from_global_point(get_global_mouse_position())
		if selected and action:
			if $Actions.selected_action != action:
				$Actions.select_action(action)
			action.start_drag()
		elif get_local_mouse_position().distance_to(Vector2.ZERO) < radius:
			select()
		elif selected:
			deselect()
			$Actions.select_action()
	elif event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
		var action = $Actions.get_action_from_global_point(get_global_mouse_position())
		if selected and action and not action is AddAction:
			$Actions.remove_action(action)

func _process(delta):
	production_timer += delta
	action_timer += delta
	if production_timer > 5.0 - (0.04 * stats[STAT.PRODUCTION]):
		production_timer = 0.0
		if active and blips.size() < stats[STAT.CAPACITY]:
			add_blip()
	if action_timer > 3.0 - (0.025 * stats[STAT.EFFICIENCY]):
		action_timer = 0.0
		if active:
			$Actions.run_actions()
	
func _draw():
	if selected:
		draw_circle(Vector2.ZERO, radius + 2, Color(0.45, 0.9, 0.5))
	draw_circle(Vector2.ZERO, radius, color)
