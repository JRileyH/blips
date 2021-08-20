extends Instruction

var MoveInstruction = preload("res://instructions/MoveInstruction.tscn")
var StandByInstruction = preload("res://instructions/StandByInstruction.tscn")
var UpgradeInstruction = preload("res://instructions/UpgradeInstruction.tscn")

const TYPE="ADD"

func start_drag():
	pass

func to_string():
	return "Add Instruction"

func add_move_instruction():
	bloid.add_instruction(MoveInstruction.instance())

func add_stand_by_instruction():
	bloid.add_instruction(StandByInstruction.instance())

func add_upgrade_instruction():
	bloid.add_instruction(UpgradeInstruction.instance())

func select():
	.select()
	$AddMove.visible = true
	$AddStandBy.visible = true
	$AddUpgrade.visible = true

func deselect():
	.deselect()
	$AddMove.visible = false
	$AddStandBy.visible = false
	$AddUpgrade.visible = false

func _ready():
	$AddMove.connect("click", self, "add_move_instruction")
	$AddStandBy.connect("click", self, "add_stand_by_instruction")
	$AddUpgrade.connect("click", self, "add_upgrade_instruction")
