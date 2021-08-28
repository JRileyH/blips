extends Instruction

const TYPE="STAND_BY"

var until: int = -1

func run():
	if until < 0:
		# Values have not yet been set for this action
		print("Skipping stand by because uninitialized")
		return false
	if not bloid.space_available(until):
		# action limit is fulfilled
		print("Skipping stand by because limit fulfilled")
		return false
	print("Standing By")
	return true

func to_string():
	return "Standing By until %s" % [until]

func _input(event):
	if selected and event is InputEventKey and event.pressed:
		var input = OS.get_scancode_string(event.scancode)
		if input == "BackSpace":
			until = -1
			update()
		elif input.is_valid_integer():
			if until <= 0:
				until = int(input)
			else:
				until = int("%s%s" % [until, input])
			update()
