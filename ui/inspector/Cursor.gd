extends Node2D

var selected_bloid: Area2D
var selected_instruction: Area2D

func click_bloid(bloid: Area2D):
	if selected_bloid != bloid:
		if selected_bloid:
			selected_bloid.deselect()
		selected_bloid = bloid
		bloid.select()

func right_click_bloid(bloid: Area2D):
	if selected_bloid == bloid:
		selected_bloid = null
		bloid.deselect()

func click_instruction(instruction: Area2D):
	if selected_instruction != instruction:
		if selected_instruction:
			selected_instruction.deselect()
		selected_instruction = instruction
		instruction.select()

func right_click_instruction(instruction: Area2D):
	if selected_instruction == instruction:
		selected_instruction = null
		instruction.deselect()

func handle_click(body: Area2D, button_index: int, pressed: bool):
	if pressed:
		match body.get_class():
			"Bloid":
				match button_index:
					BUTTON_LEFT:
						click_bloid(body)
					BUTTON_RIGHT:
						right_click_bloid(body)
			"Instruction":
				match button_index:
					BUTTON_LEFT:
						click_instruction(body)
					BUTTON_RIGHT:
						right_click_instruction(body)
