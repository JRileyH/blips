extends Node2D
class_name Blip

var distance_range = [120, 220]
var velocity_range = [0.5, 2.5]
var velocity = 1

func set_distance(val: float) -> void:
	$Sprite.position.y = val

func get_distance() -> float:
	return $Sprite.position.y

func set_velocity():
	var i = (get_distance()-distance_range[0])/(distance_range[1]-distance_range[0])
	velocity = lerp(velocity_range[1], velocity_range[0], i)

func _ready():
	randomize()
	rotation = rand_range(0.0, 2.0*PI)
	set_distance(rand_range(distance_range[0], distance_range[1]))
	set_velocity()

func _process(delta):
	rotation += velocity * delta
