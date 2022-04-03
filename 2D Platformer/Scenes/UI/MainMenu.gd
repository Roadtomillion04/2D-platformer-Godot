extends CanvasLayer

onready var play_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/StartButton
onready var character_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/CharacterSelectionButton
onready var option_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/OptionsButton
onready var quit_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton


func _ready():
	play_button.connect("pressed", self, "_on_play_button_pressed")
	character_button.connect("pressed", self, "_on_character_selection_button_pressed")
	option_button.connect("pressed", self, "_on_option_button_pressed")
	quit_button.connect("pressed", self, "_on_quit_button_pressed")

func _on_play_button_pressed():
	# resetting after game completed by player
	$"/root/LevelManager".current_level_index = 0
	$"/root/LevelManager".change_level($"/root/LevelManager".current_level_index)

func _on_character_selection_button_pressed():
	var character_selection_scene_path: String = "res://Scenes/UI/CharacterSelection.tscn"
	$"/root/ScreenTransitionManager".transition_to_scene(character_selection_scene_path)

func _on_option_button_pressed():
	# make sure it's a standolone scene we created, there we added functionality for back button pressed
	var option_menu_scene_path: String = "res://Scenes/UI/OptionMenuStandalone.tscn"
	$"/root/ScreenTransitionManager".transition_to_scene(option_menu_scene_path)

func _on_quit_button_pressed():
	get_tree().quit()
