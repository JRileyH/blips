extends Control


export(String) var label: String = "Label"
export(float) var minimum: float = 0.0
export(float) var maximum: float = 10.0
export(float) var step: float = 1.0
export(float) var default: float = 5.0

signal change

func handle_change(value):
	$Value.text = String(value)
	emit_signal("change", value)

func _ready():
	$Label.text = label + ":"
	$Value.text = String(default)
	$HSlider.min_value = minimum
	$HSlider.max_value = maximum
	$HSlider.step = step
	$HSlider.value = default
	$HSlider.connect("value_changed", self, "handle_change")
