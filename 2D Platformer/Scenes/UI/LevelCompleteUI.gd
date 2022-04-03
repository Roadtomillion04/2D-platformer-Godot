extends CanvasLayer

onready var next_level_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/NextLevelButton
onready var replay_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ReplayButton


func _ready():
	next_level_button.connect("pressed", self, "_on_next_level_button_pressed")
	replay_button.connect("pressed", self, "_on_replay_button_pressed")

func _on_next_level_button_pressed():
	# we can call scenes in autoload by
	$"/root/LevelManager".increament_level()

func _on_replay_button_pressed():
	# we ain't reload_current_scene()
	$"/root/LevelManager".reload_scene()
