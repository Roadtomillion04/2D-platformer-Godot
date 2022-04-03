extends HBoxContainer

signal volume_changed

var current_percentage: float = 1.0

func _ready():
	$SubtractVolumeButton.connect("pressed", self, "_on_volume_change_button_pressed", [-.1])
	$AddVolumeButton.connect("pressed", self, "_on_volume_change_button_pressed", [.1]) # pass args in array

func _on_volume_change_button_pressed(volume_change):
	set_volume_percentage(current_percentage + volume_change)

func set_volume_percentage(percent):
	current_percentage = clamp(percent, 0, 1)

	# converting 0 to 10, round() for db2linear() returns float
	$Label.text = str(round(current_percentage * 10))

	emit_signal("volume_changed", current_percentage)
