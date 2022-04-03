extends Node
# It is an autoload we change level instancing main node

export (Array, PackedScene) var level_scenes

var current_level_index: int = 0

func change_level(level_index):
	current_level_index = level_index # size() = len()
	if current_level_index >= level_scenes.size():
		$"/root/ScreenTransitionManager".transition_to_scene("res://Scenes/UI/GameComplete.tscn")
	else:
		$"/root/ScreenTransitionManager".transition_to_scene(level_scenes[current_level_index].resource_path) # returns filepath

func increament_level():
	change_level(current_level_index + 1)

func reload_scene(): # reloading with transition effect
	change_level(current_level_index)
