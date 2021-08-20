extends Selectable
class_name Bloid

func get_class(): return "Bloid"

var Blip = preload("res://Blip.tscn")
var AddInstruction = preload("res://instructions/AddInstruction.tscn")

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
		if claimed and blips().size() < stats[STAT.CAPACITY]:
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
		instruction.run()

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
		# TODO: Make constants
		var angle = -3*PI/8 + (i * PI/8)
		instruction.position = Vector2(cos(angle) * 90, sin(angle) * 90)
		instruction.rotation = angle

############################

###                    ###
# BLIP RELATED FUNCTIONS #
###                    ###
# TODO: check and see if adding also removes in one action

func blips():
	return $Blips.get_children()

func add_blip(blip: Node2D = null) -> Node2D:
	if not blip:
		blip = Blip.instance()
	if get_parent() == blip.get_parent():
		get_parent().remove_child(blip)
	$Blips.add_child(blip)
	return blip

func remove_blip(blip: Node2D = null) -> Node2D:
	var blips = blips()
	if blips.size() > 0 and not blip:
		blip = blips()[0]
	if not blip or blip.get_parent() != $Blips:
		return blip
	$Blips.remove_child(blip)
	get_parent().add_child(blip)
	return blip

func consume_blip(blip: Node2D = null) -> void:
	remove_blip(blip).consume()

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

