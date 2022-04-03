extends Node

const screen_transition_scene: PackedScene = preload("res://Scenes/UI/ScreenTransisition.tscn")

func transition_to_scene(scene_path):
	var screen_transition = screen_transition_scene.instance()
	add_child(screen_transition)
	
	# listens for screen_trasnsition to emit signal
	yield(screen_transition, "screen_covered")
	
	get_tree().change_scene(scene_path)

func transition_to_main_menu():
	var main_menu_scene_path: String = "res://Scenes/UI/MainMenu.tscn"
	transition_to_scene(main_menu_scene_path)
