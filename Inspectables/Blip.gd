extends Node2D
class_name Blip

var target: Inspectable = null
var angular_velocity: float = 0.0
var linear_velocity: Vector2 = Vector2.ZERO
var radius: float = 120.0

func set_distance(amt: float):
	if not target:
		return
	$BlipBody.position.x += amt

func attach(trg: Inspectable):
	if target:
		return
	$BlipBody.color = Color(0, 1, 0)
	target = trg
	var angle = global_position.angle_to_point(target.global_position)
	var distance = global_position.distance_to(target.global_position)
	global_position = target.global_position
	$BlipBody.position.x = distance
	rotation = angle
	angular_velocity = linear_velocity.length() / distance

func detach():
	if not target:
		return
	$BlipBody.color = Color(1, 0, 0)
	var new_position = $BlipBody.global_position
	rotation = 0
	$BlipBody.position.x = 0
	global_position = new_position
	var angle = global_position.angle_to_point(target.global_position)
	var distance = global_position.distance_to(target.global_position)
	linear_velocity = Vector2.DOWN.rotated(angle) * (angular_velocity * distance)
	target = null

func _ready():
	pass

func _process(delta):
	if target:
		rotation += (angular_velocity * delta)
	else:
		global_position += (linear_velocity * delta)
