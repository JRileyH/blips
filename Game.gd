extends Node

var timer: float = 0.0
onready var map = $Map
onready var inspector = $Inspector

func _ready():
	randomize()
	var starter_bloid: Bloid = map.bloids[randi() % map.bloids.size()]
	starter_bloid.activate()
	inspector.global_position = starter_bloid.global_position
	map.reveal_bloid(starter_bloid, 64)
	

func _process(delta):
	timer += delta
