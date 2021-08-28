extends Selectable
class_name Bloid

func get_class(): return "Bloid"

var Blip = preload("res://Blip.tscn")
var AddInstruction = preload("res://instructions/AddInstruction.tscn")

static func INSTRUCTION_START():
	return

var production_timer: float = 0.0
var action_timer: float = 0.0

var claimed: bool = false

var map: Node2D

static func MAX_STAT_VALUE(stat: int) -> int:
	match stat:
		STAT.VISIBILITY:
			return 100
		STAT.PRODUCTION:
			return 100
		STAT.CAPACITY:
			return 100
		STAT.EFFICIENCY:
			return 100
	return -1

enum STAT {
	VISIBILITY,
	PRODUCTION,
	CAPACITY,
	EFFICIENCY
}
var stats: Dictionary = {
	STAT.VISIBILITY: 1,
	STAT.PRODUCTION: 10,
	STAT.CAPACITY: 10,
	STAT.EFFICIENCY: 10
}

func claim():
	claimed = true
	add_instruction(AddInstruction.instance())

func update_stat(stat: int):
	if not stats.has(stat):
		push_error("%s stat not valid" % [stat])
		return
	stats[stat] += 1
	if stat == STAT.VISIBILITY:
		map.reveal_bloid(self, 64 + (stats[STAT.VISIBILITY] * 2))
	consume_blip()

func select():
	.select()
	$Instructions.visible = true

func deselect():
	.deselect()
	$Instructions.visible = false

func _process(delta):
	production_timer += delta
	action_timer += delta
	if production_timer > 5.0 - (0.04 * stats[STAT.PRODUCTION]):
		production_timer = 0.0
		if claimed and space_available():
			add_blip()
	if action_timer > 3.0 - (0.025 * stats[STAT.EFFICIENCY]):
		action_timer = 0.0
		if claimed:
			run_instructions()

###                    ###
# INSTRUCTION  FUNCTIONS #
###                    ###

func instructions():
	return $Instructions.get_children()

func run_instructions():
	for instruction in instructions():
		if instruction.run():
			break

func add_instruction(instruction: Area2D):
	if not instruction:
		return
	$Instructions.add_child(instruction)
	_position_instructions()

func remove_instruction(instruction: Area2D):
	if not instruction in instructions():
		return
	$Instructions.remove_child(instruction)
	instruction.queue_free()
	_position_instructions()

func move_instruction(instruction: Area2D, idx: int):
	if not instruction in instructions():
		return
	idx = max(min(idx, instructions().size()), 0)
	$Instructions.move_child(instruction, idx)
	_position_instructions()

func _position_instructions():
	var instructions = instructions()
	for i in instructions.size():
		var instruction = instructions[i]
		var angle = BloidConfig.INSTRUCTION_START + (i * BloidConfig.INSTRUCTION_STEP)
		instruction.position = Vector2(cos(angle) * BloidConfig.INSTRUCTION_RADIUS, sin(angle) * BloidConfig.INSTRUCTION_RADIUS)
		instruction.rotation = angle
		instruction.update()

############################

###                    ###
# BLIP RELATED FUNCTIONS #
###                    ###
# TODO: check and see if adding also removes in one action

var blips: Array = []

func space_available(until: int = INF) -> bool:
	return blips.size() < min(stats[STAT.CAPACITY], until)

func add_blip(blip: Node2D = null) -> Node2D:
	var relative_position: Vector2
	if not blip:
		blip = Blip.instance()
	if blip.bloid:
		relative_position = to_local(blip.global_position)
		blip.bloid.blips.erase(blip)
	blip.bloid = self
	if blip.get_parent():
		relative_position = to_local(blip.global_position)
		blip.get_parent().remove_child(blip)
	$Blips.add_child(blip)
	blips.append(blip)
	if relative_position:
		blip.position = relative_position
	return blip

func consume_blip(blip: Node2D = null) -> bool:
	if blips.size() > 0 and not blip:
		blip = blips[0]
	if not blip:
		return false
	blip.detach()
	blip.target = self
	blips.erase(blip)
	return true


##########################

###                    ###
# MAP BUILDING FUNCTIONS #
###                    ###

var neighbors: Array = []

func add_neighbor(neighbor: Bloid):
	if not neighbor:
		return
	if not neighbor in neighbors:
		neighbors.append(neighbor)

func remove_neighbor(neighbor: Bloid):
	if not neighbor:
		return
	if neighbor in neighbors:
		neighbors.erase(neighbor)

func distance_to(other: Bloid) -> float:
	return global_position.distance_to(other.global_position)
	
############################

