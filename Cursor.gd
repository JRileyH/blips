extends Node2D

const FOLLOW_TIMEOUT = 1.0
const COLOR = Color(0.45, 0.85, 0.55)

var _following: bool = true
var _lost_focus: bool = false
var _lost_focus_timer: float = 0.0

func _ready():
	pass

func _process(delta):
	var target = owner.get_local_mouse_position() if _following else Vector2.ZERO
	position = position.linear_interpolate(target, 0.1)
	if _lost_focus and _following:
		_lost_focus_timer += delta
		if _lost_focus_timer > FOLLOW_TIMEOUT:
			_following = false

func _draw():
	draw_circle(Vector2.ZERO, 10.0, COLOR)

func _notification(evt):
	if evt == MainLoop.NOTIFICATION_WM_MOUSE_ENTER:
		_lost_focus = false
		_following = true
	elif evt == MainLoop.NOTIFICATION_WM_MOUSE_EXIT:
		_lost_focus = true
		_lost_focus_timer = 0.0
