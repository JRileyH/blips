extends Node2D

func click_bloid(bloid: Area2D, pressed: bool):
	print(bloid)

func click_instruction(instruction: Area2D, pressed: bool):
	print(instruction)

func handle_move(e: InputEventMouseMotion, body: Area2D):
	if not e:
		return
	pass

func handle_click(body: Area2D, button_index: int, pressed: bool):
	match body.get_class():
		"Bloid":
			click_bloid(body, pressed)
		"Instruction":
			click_instruction(body, pressed)
		_:
			print("Click Unhandled")
	pass

func _ready():
	pass
