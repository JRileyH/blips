extends Instruction

const TYPE="UPGRADE"

var until: int = -1
var stat: int = -1

func run():
	if until < 0 or stat < 0:
		# Values have not yet been set for this action
		print("Skipping upgrade because uninitialized")
		return false
	if bloid.stats[stat] >= 100: # TODO: Make dynamic? Bloid.MAX_STAT_VALUE(stat):
		# bloid is at max stat
		print("Skipping upgrade because max stat")
		return false
	if bloid.stats[stat] >= until:
		# action limit is fulfilled
		print("Skipping upgrade because limit fulfilled")
		return false
	if bloid.blips.size() == 0:
		# No blips to perform action
		print("Skipping upgrade because no blips")
		return false
	bloid.update_stat(stat)
	print("Upgrading %s" % [stat_to_string(stat)])
	return true

func stat_to_string(s: int):
	match s:
		bloid.STAT.VISIBILITY:
			return "Visibility"
		bloid.STAT.PRODUCTION:
			return "Production"
		bloid.STAT.EFFICIENCY:
			return "Efficiency"
		bloid.STAT.CAPACITY:
			return "Capacity"
	return "Nothing"

func to_string():
	return "Upgrade %s until %s" % [stat_to_string(stat), until]

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

func change_to_visibility():
	stat = bloid.STAT.VISIBILITY
	color = $ChangeVisibility.color
	update()

func change_to_capacity():
	stat = bloid.STAT.CAPACITY
	color = $ChangeCapacity.color
	update()

func change_to_production():
	stat = bloid.STAT.VISIBILITY
	color = $ChangeProduction.color
	update()

func change_to_efficiency():
	stat = bloid.STAT.EFFICIENCY
	color = $ChangeEfficiency.color
	update()

func select():
	.select()
	$ChangeVisibility.visible = true
	$ChangeCapacity.visible = true
	$ChangeProduction.visible = true
	$ChangeEfficiency.visible = true

func deselect():
	.deselect()
	$ChangeVisibility.visible = false
	$ChangeCapacity.visible = false
	$ChangeProduction.visible = false
	$ChangeEfficiency.visible = false

func _ready():
	$ChangeVisibility.connect("click", self, "change_to_visibility")
	$ChangeCapacity.connect("click", self, "change_to_capacity")
	$ChangeProduction.connect("click", self, "change_to_production")
	$ChangeEfficiency.connect("click", self, "change_to_efficiency")
