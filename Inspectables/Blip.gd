extends Node2D
class_name Blip

var target: Planet = null
var orbit: Planet = null
var angular_velocity: float = 0.0
var linear_velocity: Vector2 = Vector2.ZERO
var radius: float = 120.0

func set_distance(amt: float):
	if not orbit:
		return
	angular_velocity *= $BlipBody.position.x
	$BlipBody.position.x += amt
	if $BlipBody.position.x == 0:
		angular_velocity = 1
		return
	angular_velocity /= $BlipBody.position.x

func set_target(trg: Planet):
	print("hey")
	if orbit and orbit != trg:
		detach()
	target = trg

func attach(orb: Planet):
	target = orb
	if orbit:
		return
	$BlipBody.color = Color(0, 1, 0)
	orbit = orb
	var angle = global_position.angle_to_point(orbit.global_position)
	var distance = global_position.distance_to(orbit.global_position)
	global_position = orbit.global_position
	$BlipBody.position.x = distance
	rotation = angle
	angular_velocity = linear_velocity.length() / distance if distance != 0 else 0 

func detach():
	if not orbit:
		return
	$BlipBody.color = Color(1, 0, 0)
	var angle = rotation
	var distance = $BlipBody.position.x
	var new_position = $BlipBody.global_position
	rotation = 0
	$BlipBody.position.x = 0
	global_position = new_position
	
	linear_velocity = Vector2.DOWN.rotated(angle) * (angular_velocity * distance)
	orbit = null

func _ready():
	pass

func _process(delta):
	if orbit:
		rotation += (angular_velocity * delta)
	else:
		if target:
			pass
		global_position += (linear_velocity * delta)
