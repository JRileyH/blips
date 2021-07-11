extends Node2D

export (float) var radius = 12.0
export(Color) var color = Color(0.6, 0.6, 0.6)

func _draw():
	draw_circle(Vector2.ZERO, radius, color)
