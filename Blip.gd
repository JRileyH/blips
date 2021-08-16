extends Node2D
class_name Blip

var target = null
var orbit = null
var angular_velocity: float = 0.0
var linear_velocity: float = 0.0
var linear_direction: Vector2
var path: Array = []

var traveling: bool = false
var approach_timer: float = 0.0
var random_distance: float = 300.0

signal attach
signal detach
signal target

var noise = OpenSimplexNoise.new()
var timer: float = 0.0
var noise_timer: float = 0.0
var noise_sample: float = 0.0

func set_distance(amt: float):
	if not orbit or amt == 0:
		return
	angular_velocity *= $BlipBody.position.x
	$BlipBody.position.x = amt
	angular_velocity /= $BlipBody.position.x

func shift_distance(amt: float = 1):
	set_distance($BlipBody.position.x + amt)

func set_path(pth: Array):
	path = pth

func set_target(trg: Node2D):
	if orbit and orbit == trg:
		return
	emit_signal("target", trg)
	detach()
	traveling = true
	target = trg
	randomize()
	random_distance = rand_range(100, 300)

func attach(trg: Node2D):
	if orbit:
		return
	emit_signal("attach", trg)
	var angle = global_position.angle_to_point(trg.global_position)
	var distance = global_position.distance_to(trg.global_position)
	if distance < 1:
		distance = 1
	target = null
	orbit = trg
	var parent = get_parent()
	if parent != orbit:
		if parent:
			parent.remove_child(self)
		orbit.add_child(self)
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
	orbit.remove_blip(self)
	orbit = null

func set_color(c: Color = Color(0.6, 0.6, 0.6)):
	$BlipBody.color = c
	$BlipBody.update()

func _ready():
	randomize()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 10.0
	noise.persistence = 0.8


func _process(delta):
	timer += delta
	if timer > 10:
		noise_timer += timer
		timer = 0.0
		noise_sample = noise.get_noise_1d(noise_timer)
	if orbit:
		rotation += (angular_velocity * delta)
		var distance = 150 + (100 * noise_sample)
		if $BlipBody.position.x < distance:
			shift_distance()
		elif $BlipBody.position.x > distance:
			shift_distance(-1)
		if path.size() > 0:
			set_target(path.pop_front())
	else:
		if target:
			var angle = global_position.angle_to_point(target.global_position)
			var distance = global_position.distance_to(target.global_position)
			if traveling and distance < random_distance:
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
