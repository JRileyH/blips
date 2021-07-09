extends Node2D
class_name Bloid

export (float) var radius = 100.0
export(Color) var color = Color(0.6, 0.6, 0.6)

func _ready():
	pass

func _draw():
	draw_circle(Vector2.ZERO, radius, color)
