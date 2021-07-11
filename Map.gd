extends Node2D

const BLIP_VELOCITY: float = 100.0
const MAP_SIZE: int = 3
const BLOID_DENSITY: int = 15
const MAX_BLIPS: int = 0

var Bloid = preload("res://Bloid.tscn")
var Blip = preload("res://Blip.tscn")

var bloids: Array = []
var blips: Array = []


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

func create_random_bloid() -> Bloid:
	randomize()
	var w = ProjectSettings.get_setting("display/window/size/width")
	var h = ProjectSettings.get_setting("display/window/size/height")
	var random_position = Vector2(
		rand_range(-w * MAP_SIZE, (w * MAP_SIZE) + w),
		rand_range(-h * MAP_SIZE, (h * MAP_SIZE) + h)
	)
	var blip_count: int = randi()%(MAX_BLIPS+1)
	var blip_data: PoolVector2Array = []
	for i in blip_count:
		blip_data.append(get_random_blip_position())
		
	return create_bloid(random_position, blip_data)

var triangles: Array
func _ready():
	var bloid_points: PoolVector2Array
	for i in BLOID_DENSITY * MAP_SIZE:
		bloid_points.append(create_random_bloid().global_position)
	triangles = BowyerWatson.triangulate(bloid_points)

func _draw():
	for t in triangles:
		t.draw(self)
