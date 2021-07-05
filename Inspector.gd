extends Node2D

var direction: Vector2 = Vector2.ZERO
var target = null

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
	pass

func _process(delta):
	position += get_move_input() * delta * 500
	if Input.is_action_pressed("reset"):
		rotation = 0.0
	else:
		rotation += get_rotation_input() * delta
