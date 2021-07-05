extends Node2D
class_name Inspectable

export (float) var radius = 100.0
export(Color) var color = Color(0.6, 0.6, 0.6)

func _ready():
	pass # Replace with function body.

func _process(delta):
	update()

func _draw():
	draw_circle(Vector2.ZERO, radius, color)
