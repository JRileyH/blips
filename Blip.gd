extends Node2D
class_name Blip

var target: Bloid = null
var orbit: Bloid = null
var angular_velocity: float = 0.0
var linear_velocity: float = 0.0
var linear_direction: Vector2

var traveling: bool = false
var approach_timer: float = 0.0

signal attach
signal detach
signal target

func set_distance(amt: float):
	if not orbit or amt == 0:
		return
	angular_velocity *= $BlipBody.position.x
	$BlipBody.position.x = amt
	angular_velocity /= $BlipBody.position.x

func shift_distance(amt: float):
	set_distance($BlipBody.position.x + amt)

func set_target(trg: Bloid):
	if orbit and orbit == trg:
		return
	emit_signal("target", trg)
	detach()
	traveling = true
	target = trg

func attach(trg: Bloid):
	if orbit:
		return
	emit_signal("attach", trg)
	target = null
	orbit = trg
	var parent = get_parent()
	if parent:
		parent.remove_child(self)
	orbit.add_child(self)
	var angle = global_position.angle_to_point(orbit.global_position)
	var distance = global_position.distance_to(orbit.global_position)
	global_position = orbit.global_position
	$BlipBody.position.x = distance
	rotation = angle
	angular_velocity = linear_velocity / distance if distance != 0 else 0

func detach():
	if not orbit:
		return
	emit_signal("detach", orbit)
	var angle = rotation
	var distance = $BlipBody.position.x
	var new_position = $BlipBody.global_position
	rotation = 0
	$BlipBody.position.x = 0
	global_position = new_position
	linear_direction = Vector2.DOWN.rotated(angle)
	linear_velocity =  angular_velocity * distance
	orbit = null

func _ready():
	var trg = get_parent()
	linear_velocity = global_position.distance_to(trg.global_position)
	attach(trg)

func _process(delta):
	if orbit:
		rotation += (angular_velocity * delta)
	else:
		if target:
			var angle = global_position.angle_to_point(target.global_position)
			var distance = global_position.distance_to(target.global_position)
			if traveling and distance < 300:
				traveling = false
				approach_timer = 0.0
			if not traveling:
				approach_timer += delta
				if approach_timer > 1:
					attach(target)
					return
			var normal = Vector2.LEFT if traveling else Vector2.DOWN
			linear_direction = linear_direction.linear_interpolate(normal.rotated(angle), 0.01)
			
		global_position += linear_direction * (linear_velocity * delta)
