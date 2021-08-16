extends Node2D

var direction: Vector2 = Vector2.ZERO

func get_move_input() -> Vector2:
	direction = Vector2.ZERO
	direction += (Input.get_action_strength("move_down") * Vector2.DOWN)
	direction += (Input.get_action_strength("move_up") * Vector2.UP)
	direction += (Input.get_action_strength("move_left") * Vector2.LEFT)
	direction += (Input.get_action_strength("move_right") * Vector2.RIGHT)
	direction = direction.normalized().rotated(rotation)
	return direction

func get_rotation_input() -> float:
	var r = 0.0
	r -= Input.get_action_strength("rotate_left")
	r += Input.get_action_strength("rotate_right")
	return r

func _ready():
	$Camera2D.zoom = Vector2.ONE * 7.0
	var map = get_node("../Map")
	$CanvasLayer/Control/Panel/Radius.connect("change", map, "set_map_size")
	$CanvasLayer/Control/Panel/Density.connect("change", map, "set_bloid_density")
	$CanvasLayer/Control/Panel/Connectivity.connect("change", map, "set_connectivity")
	$CanvasLayer/Control/Panel/Randomness.connect("change", map, "set_randomness")
	$CanvasLayer/Control/Panel/Rebuild.connect("pressed", map, "build")

func _process(delta):
	position += get_move_input() * delta * 1500
	if Input.is_action_pressed("reset"):
		rotation = 0.0
	else:
		rotation += get_rotation_input() * delta

func _input(event):
	if event is InputEventPanGesture:
		var new_zoom = $Camera2D.zoom + Vector2(event.delta.y, event.delta.y).normalized() * 0.2
		if new_zoom.y <= 0.1 or new_zoom.y >= 50:
			return
		$Camera2D.zoom = new_zoom
	elif event is InputEventMouseButton:
		if event.is_pressed() and (event.button_index == BUTTON_WHEEL_UP or event.button_index == BUTTON_WHEEL_DOWN):
			var new_zoom = $Camera2D.zoom
			if event.button_index == BUTTON_WHEEL_UP:
				new_zoom += Vector2.ONE * 0.5
			elif event.button_index == BUTTON_WHEEL_DOWN:
				new_zoom -= Vector2.ONE * 0.5
			if new_zoom != $Camera2D.zoom and new_zoom.y > 0.1 and new_zoom.y < 50:
				$Camera2D.zoom = new_zoom
	elif event is InputEventKey:
		if event.is_pressed() and (event.scancode == KEY_BRACELEFT or event.scancode == KEY_BRACERIGHT):
			var new_zoom = $Camera2D.zoom
			if event.scancode == KEY_BRACELEFT:
				new_zoom += Vector2.ONE
			elif event.scancode == KEY_BRACERIGHT:
				new_zoom -= Vector2.ONE
			if new_zoom != $Camera2D.zoom and new_zoom.y > 0.1 and new_zoom.y < 50:
				$Camera2D.zoom = new_zoom
