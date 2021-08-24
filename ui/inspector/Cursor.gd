extends Node2D

var hovered_selectable: Area2D
var selected_bloid: Area2D
var selected_instruction: Area2D

func click_bloid(bloid: Area2D):
	if selected_instruction and selected_instruction.TYPE == "MOVE" and bloid != selected_instruction.bloid:
		selected_instruction.target = bloid
		selected_instruction.update()
	elif selected_bloid != bloid:
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
	else:
		instruction.start_drag()

func right_click_instruction(instruction: Area2D):
	if instruction.TYPE != "ADD":
		instruction.bloid.remove_instruction(instruction)

func handle_click(body: Area2D, event: InputEventMouseButton):
	if event.pressed:
		match body.get_class():
			"Bloid":
				match event.button_index:
					BUTTON_LEFT:
						click_bloid(body)
					BUTTON_RIGHT:
						right_click_bloid(body)
			"Instruction":
				match event.button_index:
					BUTTON_LEFT:
						click_instruction(body)
					BUTTON_RIGHT:
						right_click_instruction(body)

func handle_hover(body: Area2D, hovered: bool):
	hovered_selectable = body if hovered else null

func _input(event):
	if event is InputEventMouseButton and event.pressed and not hovered_selectable:
		if selected_bloid:
			selected_bloid.deselect()
			selected_bloid = null
		if selected_instruction:
			selected_instruction.deselect()
			selected_instruction = null
