extends Node

export(Color, RGB) var background_color

# character selection, default first
var player_animation: String = "res://resources/Character/Player_animation_default.tres"

func _init():
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	
	OS.set_window_position(screen_size * 0.5 - window_size * 0.5)
	
	# bg color for game not editor
	VisualServer.set_default_clear_color("dff6f5")

func _unhandled_input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()
	elif event.is_action_pressed("reload"):
		var __ = get_tree().reload_current_scene()

# camera shake
func apply_camera_shake(percenentage):
	var cameras: Array = get_tree().get_nodes_in_group("Camera")
	if cameras.size() > 0: # for safe
		var camera = cameras[0]
		camera.apply_shake(percenentage)

