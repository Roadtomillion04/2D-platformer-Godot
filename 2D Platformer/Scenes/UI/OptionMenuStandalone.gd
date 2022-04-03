extends CanvasLayer

# Option button in main menu to make screen_transitions

func _ready():
	$OptionsMenu.connect("back_pressed", self, "_on_option_back_button_pressed")

func _on_option_back_button_pressed():
	$"/root/ScreenTransitionManager".transition_to_main_menu()
