extends CanvasLayer

onready var default_character_button: Button = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/DefaultCharacterButton
onready var blue_character_button: Button = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/BlueCharacterButton
onready var green_character_button: Button = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/GreenCharacterButton
onready var orange_character_button: Button = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/OrangeCharacterButton
onready var yellow_character_button: Button = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/YellowCharacterButton

var default_character_path = "res://resources/Character/Player_animation_default.tres"
var blue_character_path = "res://resources/Character/Player_animation_blue.tres"
var green_character_path = "res://resources/Character/Player_animation_green.tres"
var orange_character_path = "res://resources/Character/Player_animation_orange.tres"
var yellow_character_path = "res://resources/Character/Player_animation_yellow.tres"

func _ready():
	default_character_button.connect("pressed", self, "_on_character_change_button_pressed", [default_character_path])
	
	blue_character_button.connect("pressed", self, "_on_character_change_button_pressed", [blue_character_path])
	
	green_character_button.connect("pressed", self, "_on_character_change_button_pressed", [green_character_path])
	
	orange_character_button.connect("pressed", self, "_on_character_change_button_pressed", [orange_character_path])
	
	yellow_character_button.connect("pressed", self, "_on_character_change_button_pressed", [yellow_character_path])
	

func _on_character_change_button_pressed(character_animation):
	# setting autoload path variable
	$"/root/Helpers".player_animation = character_animation

	# back to main menu
	$"/root/ScreenTransitionManager".transition_to_main_menu()

