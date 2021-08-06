extends Node2D

const BLIP_VELOCITY: float = 100.0
var MAP_SIZE: int = 4000
var BLOID_DENSITY: float = 0.01
var CONNECTIVITY: float = 0.25
var RANDOMNESS: float = 0.5
var MAX_BLIPS: int = 5


var Bloid = preload("res://Bloid.tscn")
var Blip = preload("res://Blip.tscn")

var selected_bloid = null
var bloids: Array = []
var blips: Array = []

onready var space = $Space

func set_map_size(value):
	MAP_SIZE = value

func set_bloid_density(value):
	BLOID_DENSITY = value * 0.1

func set_connectivity(value):
	CONNECTIVITY = value

func set_randomness(value):
	RANDOMNESS = value

func set_max_blips(value):
	MAX_BLIPS = value

func _bloid_too_close(point: Vector2) -> bool:
	for bloid in bloids:
		if bloid.global_position.distance_to(point) < 500:
			return true
	return false

func _get_random_point(radius: float, origin: Vector2, retry: int = 0) -> Vector2:
	randomize()
	var angle = rand_range(0, PI*2)
	var distance = rand_range(-radius, radius)
	var point = Vector2(
		cos(angle) * distance,
		sin(angle) * distance
	) + origin
	if retry > 10:
		return point
	if _bloid_too_close(point):
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
	parent.add_child(new_blip)
	blips.append(new_blip)
	new_blip.global_position = parent.global_position + relative_pos
	new_blip.linear_velocity = BLIP_VELOCITY
	new_blip.attach(parent)
	return new_blip

func create_bloid(global_pos: Vector2, blip_coords: PoolVector2Array = []) -> Bloid:
	var new_bloid = Bloid.instance()
	space.add_child(new_bloid)
	bloids.append(new_bloid)
	new_bloid.global_position = global_pos
	for blip_pos in blip_coords:
		create_blip(new_bloid, blip_pos)
	return new_bloid

func create_random_bloid(max_radius: float = MAP_SIZE, origin: Vector2 = Vector2.ZERO) -> Bloid:
	var random_position = _get_random_point(max_radius, origin)
	var blip_count: int = randi()%(MAX_BLIPS+1)
	var blip_data: PoolVector2Array = []
	for i in blip_count:
		blip_data.append(get_random_blip_position())
		
	return create_bloid(random_position, blip_data)

var connections: Array = []

func build():
	b = 0
	$Fog.reset()
	# RESET WORLD
	for blip in blips:
		blip.queue_free()
	blips = []
	for bloid in bloids:
		bloid.disconnect("selected", self, "handle_select_bloid")
		bloid.queue_free()
	bloids = []
	connections = []

	# PLACE BLOIDS
	var bloid_points: PoolVector2Array = []
	var bloid_map: Dictionary = {}
	for i in round(MAP_SIZE * BLOID_DENSITY):
		var new_bloid = create_random_bloid()
		bloid_map[new_bloid.global_position] = new_bloid
		bloid_points.append(new_bloid.global_position)
		new_bloid.connect("selected", self, "handle_select_bloid")

	# GENERATE DEULANCY TRIANGULATION
	var super_triangle = BowyerWatson.min_inscribed_triangle(MAP_SIZE, Vector2.ZERO)
	var triangulation = BowyerWatson.triangulate_lines(super_triangle, bloid_points)
	
	# GENERATE MINIMAL SPANNING TREE
	var minimal_span = MinimalSpanningTree.find(bloid_points)
	
	if triangulation.size() == 0:
		return minimal_span
	
	# GENERATE EXTRA CONNECTIONS
	var EXTRA_SIZE: int = floor((triangulation.size() - minimal_span.size()) * CONNECTIVITY)
	
	# FIRST PART IS THE LOWEST SPANNING CONNECTIONS
	var lowest_extras = []
	var largest_extra: Geom.Line = triangulation[0]
	for line in triangulation:
		var already_used: bool = false
		for l in minimal_span:
			if l.equals(line):
				already_used = true
				continue
		if already_used:
			continue
		if lowest_extras.size() < floor(EXTRA_SIZE * (1 - RANDOMNESS)):
			lowest_extras.append(line)
			if line.length() > largest_extra.length():
				largest_extra = line
		else:
			if line.length() < largest_extra.length():
				lowest_extras.erase(largest_extra)
				lowest_extras.append(line)
				largest_extra = lowest_extras[0]
				for l in lowest_extras:
					if l.length() > largest_extra.length():
						largest_extra = l
	
	# REST IS SELECTED RANDOMLY
	var random_extras = []
	while random_extras.size() < floor(EXTRA_SIZE * RANDOMNESS):
		randomize()
		var connection = triangulation[randi() % triangulation.size()]
		for line in minimal_span:
			if line.equals(connection):
				triangulation.erase(connection)
				continue
		for line in lowest_extras:
			if line.equals(connection):
				triangulation.erase(connection)
				continue
		random_extras.append(connection)
	
	connections = minimal_span + lowest_extras + random_extras
	
	for line in connections:
		var bloid1 = bloid_map[line.points()[0]]
		var bloid2 = bloid_map[line.points()[1]]
		if bloid1 and bloid2:
			bloid1.add_neighbor(bloid2)
			bloid2.add_neighbor(bloid1)
	
	update()

func handle_select_bloid(bloid: Bloid):
	bloid.set_color(Color(0.1, 0.8, 0.4))
	for blip in blips:
		var start = blip.orbit if blip.orbit else blip.target
		blip.set_path(Dijkstra.shortest_path(bloids, start, bloid))

var timer: float = 0.0
var b: int = 0
func _process(delta):
	timer += delta
	if timer > 0.1:
		timer = 0.0
		if b < bloids.size():
			$Fog.reveal_bloid(bloids[b])
			b += 1
		

func _ready():
	build()

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		for bloid in bloids:
			bloid.set_color()

func _draw():
	for c in connections:
		c.draw(self)
