extends Node2D

func _ready():
	pass

func _process(_delta):
	pass

func _input(event):
	$Camera2D.handle_camera_zoom(event)
	$Camera2D.handle_camera_pan(event)
	$Camera2D.handle_camera_roll(event)
