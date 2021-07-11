extends Node2D

const BLIP_VELOCITY: float = 100.0
const MAP_SIZE: int = 3000
const BLOID_DENSITY: float = 0.01
const MAX_BLIPS: int = 0

var Bloid = preload("res://Bloid.tscn")
var Blip = preload("res://Blip.tscn")

var bloids: Array = []
var blips: Array = []

func _bloid_too_close(point: Vector2) -> bool:
	for bloid in bloids:
		if bloid.global_position.distance_to(point) < 500:
			return true
	return false

func _get_random_point(radius: float, origin: Vector2, retry: int = 0) -> Vector2:
	if retry > 10:
		return Vector2.ZERO
	randomize()
	var angle = rand_range(0, PI*2)
	var distance = rand_range(-radius, radius)
	var point = Vector2(
		cos(angle) * distance,
		sin(angle) * distance
	) + origin
	while _bloid_too_close(point) and point != Vector2.ZERO:
		point = _get_random_point(radius, origin, retry + 1)
	return point

func get_random_blip_position() -> Vector2:
	randomize()
	var distance = rand_range(100, 300)
	var angle = rand_range(0, 2*PI)
	return Vector2(
		cos(angle) * distance,
		sin(angle) * distance
	)

func create_blip(parent: Bloid, relative_pos: Vector2) -> Blip:
	var new_blip = Blip.instance()
	# parent.add_child(new_blip)
	new_blip.global_position = parent.global_position + relative_pos
	new_blip.linear_velocity = BLIP_VELOCITY
	blips.append(new_blip)
	new_blip.attach(parent)
	return new_blip

func create_bloid(global_pos: Vector2, blips: PoolVector2Array = []) -> Bloid:
	var new_bloid = Bloid.instance()
	new_bloid.global_position = global_pos
	bloids.append(new_bloid)
	for blip_pos in blips:
		create_blip(new_bloid, blip_pos)
	add_child(new_bloid)
	return new_bloid

func create_random_bloid(max_radius: float = MAP_SIZE, origin: Vector2 = Vector2.ZERO) -> Bloid:
	var random_position = _get_random_point(max_radius, origin)
	var blip_count: int = randi()%(MAX_BLIPS+1)
	var blip_data: PoolVector2Array = []
	for i in blip_count:
		blip_data.append(get_random_blip_position())
		
	return create_bloid(random_position, blip_data)

var triangles: Array
func _ready():
	var bloid_points: PoolVector2Array
	for i in round(MAP_SIZE * BLOID_DENSITY):
		bloid_points.append(create_random_bloid().global_position)
	var super_triangle: BowyerWatson.Triangle = BowyerWatson.min_inscribed_triangle(MAP_SIZE, Vector2.ZERO)
	triangles = BowyerWatson.triangulate(super_triangle, bloid_points)

func _draw():
	for t in triangles:
		t.draw(self)
