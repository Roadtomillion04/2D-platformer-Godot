extends CanvasLayer

onready var continue_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ContinueButton

func _ready():
	continue_button.connect("pressed", self, "_on_continue_to_main_menu_button_pressed")

func _on_continue_to_main_menu_button_pressed():
	$"/root/ScreenTransitionManager".transition_to_main_menu()
