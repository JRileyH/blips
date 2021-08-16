extends Node2D
class_name Bloid

var Blip = preload("res://Blip.tscn")

export (float) var radius = 40.0
export(Color) var color = Color(0.6, 0.6, 0.6)

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

enum STAT {
	VISIBILITY,
	PRODUCTION,
	CAPACITY,
	RATE
}
var stats: Dictionary = {
	STAT.VISIBILITY: 10,
	STAT.PRODUCTION: 10,
	STAT.CAPACITY: 10,
	STAT.RATE: 10
}

func activate():
	active = true
	$Actions.add_action(
		AddAction.new()
	)

func add_blip():
	var blip = Blip.instance()
	add_child(blip)
	blip.linear_velocity = 100.0
	blip.attach(self)
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
			$Actions.select_action(action)
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
	if production_timer > 5.0:
		production_timer = 0.0
		if active and blips.size() < stats[STAT.CAPACITY]:
			add_blip()
	if action_timer > 5.0:
		action_timer = 0.0
	
func _draw():
	if selected:
		draw_circle(Vector2.ZERO, radius + 2, Color(0.45, 0.9, 0.5))
	draw_circle(Vector2.ZERO, radius, color)
