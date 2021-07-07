extends Node

var timer: float = 0.0
onready var planet: Planet = get_node("Planet")
onready var blip: Blip = get_node("Planet/Blip")


func _ready():
	# Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	# blip.attach(planet)
	blip.angular_velocity = 0.63
	pass

func _process(delta):
	timer += delta
	if timer > 2:
		timer = 0.0
		if not blip.target:
			blip.attach(planet)
		else:
			blip.detach()
