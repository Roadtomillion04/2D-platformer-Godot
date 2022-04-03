extends CanvasLayer

const option_menu_scene: PackedScene = preload("res://Scenes/UI/OptionsMenu.tscn")

onready var continue_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ContinueButton
onready var option_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/OptionsButton
onready var quit_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton

func _ready():
	continue_button.connect("pressed", self, "_on_continue_button_pressed")
	option_button.connect("pressed", self, "_on_option_button_pressed")
	quit_button.connect("pressed", self, "_on_quit_to_main_button_pressed")
	get_tree().paused = true

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		unpause()
		get_tree().set_input_as_handled()

func _on_continue_button_pressed():
	unpause()

func unpause():
	queue_free()
	get_tree().paused = false

func _on_option_button_pressed():
	# here we want to instance pause scene so player won't loose progress
	var option_menu_instance = option_menu_scene.instance()
	add_child(option_menu_instance)
	option_menu_instance.connect("back_pressed", self, "_on_option_back_button_pressed")
	
	$MarginContainer.visible = false

func _on_quit_to_main_button_pressed():
	unpause()
	$"/root/ScreenTransitionManager".transition_to_main_menu()

func _on_option_back_button_pressed():
	$OptionsMenu.queue_free() # while running add_child() instances it
	$MarginContainer.visible = true
