extends Node2D

func select_action(action = null):
	if action == null and selected_action != null:
		selected_action.deselect()
		selected_action = null
	if not action in actions:
		return
	if selected_action:
		selected_action.deselect()
	selected_action = action
	selected_action.select()

func get_action_from_global_point(point: Vector2):
	for action in actions:
		if action.contains_point(point):
			return action
	return null
