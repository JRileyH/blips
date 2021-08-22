extends Instruction

const TYPE="MOVE"

var target: Area2D
var until: int = -1

func run():
	if until < 0 or target == null:
		# Values have not yet been set for this action
		print("Skipping move to because uninitialized")
		return false
	if target.blips.size() >= target.stats[target.STAT.CAPACITY]:
		# target bloid is at max capacity
		print("Skipping move to because max target capacity")
		return false
	if target.blips.size() >= until:
		# action limit is fulfilled
		print("Skipping move to because limit fulfilled")
		return false
	if bloid.blips.size() == 0:
		# No blips to perform action
		print("Skipping move to because no blips")
		return false
	target.add_blip(bloid.blips[0])
	print("Moving")
	return true

func to_string():
	return "Move to %s until %s" % ["target" if target else "no where", until]

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

func _draw():
	if selected and target:
		draw_line(Vector2.ZERO, to_local(target.global_position), Color(0.7, 0.45, 0.55), 3.0, true)
	._draw()
