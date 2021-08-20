extends Area2D
class_name Selectable
func get_class(): return "Selectable"

const SELECTION_WIDTH: int = 2
const SELECTION_COLOR: Color = Color(0.45, 0.9, 0.5)
const HOVER_COLOR: Color = Color(0.8, 0.2, 0.6)

export (float) var radius: float = 10.0
export (Color) var color: Color = Color(1.0, 1.0, 1.0)

var hovered: bool = false;
signal hovered
signal unhovered
var selected: bool = false;
signal selected
signal deselected

var area: CollisionShape2D
onready var cursor = get_node("/root/Game/Inspector/Cursor")

func select():
	selected = true
	emit_signal("selected", self)
	update()

func deselect():
	selected = false
	emit_signal("deselected", self)
	update()

func hover():
	hovered = true
	emit_signal("hovered", self)
	update()

func unhover():
	hovered = false
	emit_signal("unhovered", self)
	update()

func handle_input_event(_viewport: Node, event: InputEventMouseButton, _shape_idx: int):
	if event:
		cursor.handle_click(self, event.button_index, event.pressed)

func _ready():
	area = CollisionShape2D.new()
	area.shape = CircleShape2D.new()
	area.shape.radius = radius
	add_child(area)
	connect("input_event", self, "handle_input_event")
	connect("mouse_entered", self, "hover")
	connect("mouse_exited", self, "unhover")

func _draw():
	if selected:
		draw_circle(Vector2.ZERO, radius + SELECTION_WIDTH, SELECTION_COLOR)
	elif hovered:
		draw_circle(Vector2.ZERO, radius + SELECTION_WIDTH, HOVER_COLOR)
	draw_circle(Vector2.ZERO, radius, color)
