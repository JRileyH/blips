extends Node

var timer: float = 0.0
onready var planet: Planet = get_node("Planet")
onready var planet2: Planet = get_node("Planet2")
onready var blip: Blip = get_node("Planet/Blip")
onready var blip2: Blip = get_node("Planet/Blip2")

func _ready():
	# Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	blip.attach(planet)
	blip.angular_velocity = 1
	blip2.attach(planet)
	blip2.angular_velocity = 2
	pass

func _process(delta):
	timer += delta
	if timer > 2:
		timer = 0.0
		if not blip.orbit:
			blip.attach(planet)
		else:
			blip.detach()

func _input(event):
	if event.is_action_pressed("rotate_left"):
		blip.set_distance(-10)
	elif event.is_action_pressed("rotate_right"):
		blip.set_distance(10)
	elif event.is_action_pressed("reset"):
		if blip2.target == planet:
			blip2.set_target(planet2)
		elif blip2.target == planet2:
			blip2.set_target(planet)
