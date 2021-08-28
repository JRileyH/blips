extends Node2D
class_name Blip

var angular_velocity: float = 0.0
var linear_velocity: float = 0.0
var linear_direction: Vector2
var path: Array = []

var bloid: Area2D
var target: Area2D
var attached: bool = false

var flip: int = 1

func set_distance(amt: float):
	angular_velocity *= $BlipBody.position.x
	$BlipBody.position.x = amt
	angular_velocity /= $BlipBody.position.x

func shift_distance(amt: float = 1):
	set_distance($BlipBody.position.x + amt)

func set_path(pth: Array):
	path = pth

func attach():
	if attached:
		return
	var angle = global_position.angle_to_point(get_parent().global_position)
	var distance = max(1, global_position.distance_to(get_parent().global_position))
	position = Vector2.ZERO
	$BlipBody.position.x = distance
	rotation = angle
	angular_velocity = linear_velocity / distance
	attached = true

func detach():
	if not attached:
		return
	var angle = rotation
	var distance = $BlipBody.position.x
	var new_position = $BlipBody.global_position
	rotation = 0
	$BlipBody.position.x = 0
	global_position = new_position
	linear_direction = Vector2.DOWN.rotated(angle)
	linear_velocity =  angular_velocity * distance
	attached = false

var orbit: float = 100.0
func _ready():
	add_to_group('blips')
	linear_velocity = 100.0
	attach()
	randomize()
	orbit += rand_range(0.0, 200.0)
	flip = 1 if bool(randi() % 2) else -1

func move_in_space(delta: float, trg: Vector2, bounds: float = orbit, ease_in: bool = true) -> bool:
	var angle = global_position.angle_to_point(trg)
	var distance = global_position.distance_to(trg)
	var target_direction = Vector2.LEFT.rotated(angle)
	if ease_in and distance < bounds + 100:
		target_direction = Vector2.DOWN.rotated(angle)
	linear_direction = linear_direction.linear_interpolate(target_direction, 0.01)
	global_position += linear_direction * (linear_velocity * delta)
	return distance < bounds

func _process(delta):
	if path.size() > 0 and path[0].space_available():
		if attached:
			detach()
		if not target:
			target = path[0]
		if move_in_space(delta, target.global_position):
			target.add_blip(self)
			attach()
			target = null
			path.pop_front()
	elif target:
		if move_in_space(delta, target.global_position, 20.0, false):
			print("consumed")
			queue_free()
			update()
	elif attached:
		var distance = $BlipBody.global_position.distance_to(get_parent().global_position)
		if distance > orbit + 10:
			return detach()
		rotation += flip * (angular_velocity * delta)
		if distance < orbit - 10:
			shift_distance()
	else:
		move_in_space(delta, get_parent().global_position)
