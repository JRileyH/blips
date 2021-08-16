extends Node2D

const RADIUS = 90
const ACTION_STEP = PI/8
const ACTION_START = -3*PI/8

onready var actions: Array = []
var selected_action = null


func _bind_index(index, size):
	if index == null or index > size:
		index = size
	if index < 0:
		index = 0
	return index

func _replace_action_positions():
	for i in actions.size():
		var action = actions[i]
		var angle = ACTION_START + (i * ACTION_STEP)
		action.reposition(i, angle, Vector2(cos(angle) * RADIUS, sin(angle) * RADIUS))

func add_action(action, at_index = null):
	add_child(action)
	at_index = _bind_index(at_index, actions.size())
	actions.insert(at_index, action)
	_replace_action_positions()

func select_action(action = null):
	if action == null:
		selected_action.deselect()
		selected_action = null
	if not action in actions:
		return
	if selected_action:
		selected_action.deselect()
	selected_action = action
	selected_action.select()

func move_action(action, at_index = null):
	if not action in actions:
		return
	actions.erase(action)
	at_index = _bind_index(at_index, actions.size())
	actions.insert(at_index, action)
	_replace_action_positions()

func remove_action(action):
	if not action in actions:
		return
	actions.erase(action)
	action.queue_free()
	_replace_action_positions()

func get_action_from_global_point(point: Vector2):
	for action in actions:
		if action.contains_point(point):
			return action
	return null
