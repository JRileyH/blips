extends Node2D
class_name Blip

var target: Inspectable = null
var angular_velocity: float = 0.0
var linear_velocity: Vector2 = Vector2.ZERO


func attach(trg: Inspectable):
	if target:
		return
	$BlipBody.color = Color(0, 1, 0)
	print("Attach")
	target = trg
	var angle = global_position.angle_to_point(target.global_position)
	var distance = global_position.distance_to(target.global_position)
	global_position = target.global_position
	$BlipBody.position.x = distance
	rotation = angle
	print(angle)
	# convert linear_velocity into angular_velocity 

func detach():
	if not target:
		return
	$BlipBody.color = Color(1, 0, 0)
	print("Detach")
	var angle = rotation
	var distance = $BlipBody.position.x
	rotation = 0
	$BlipBody.position.x = 0
	global_position = target.global_position + Vector2(
		distance * sin(angle),
		distance * cos(angle)
	)
	print(angle)
	# convert angular_velocity into linear_velocity
	target = null

func _ready():
	pass

func _process(delta):
	if target:
		rotation += (angular_velocity * delta)
	else:
		pass

func _draw():
	draw_circle(Vector2.ZERO, 2, Color(0, 0, 1))
