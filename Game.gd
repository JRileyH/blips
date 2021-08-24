extends Node

var timer: float = 0.0
onready var map = $Map
onready var inspector = $Inspector

func _ready():
	randomize()
	var starter_bloid = map.bloids[randi() % map.bloids.size()]
	starter_bloid.claim()
	inspector.global_position = starter_bloid.global_position
	map.reveal_bloid(starter_bloid, 256)
	

func _process(delta):
	timer += delta
