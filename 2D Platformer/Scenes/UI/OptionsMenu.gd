extends CanvasLayer

onready var window_mode_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/WindoModeContainer/WinodowModeButton
onready var back_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BackButton
onready var music_range_control = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/MusicVolumeContainer/VolumeRangeController
onready var sfx_range_control = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/SFXVolumeContainer/VolumeRangeController

signal back_pressed

func _ready():
	window_mode_button.connect("pressed", self, "_on_window_mode_button_pressed")
	back_button.connect("pressed", self, "_on_back_button_pressed")
	update_display()

	music_range_control.connect("volume_changed", self, "_on_music_volume_changed")
	sfx_range_control.connect("volume_changed", self, "_on_sfx_volume_changed")
	update_voulme_label_display()

func _on_window_mode_button_pressed():
	OS.window_fullscreen = not OS.window_fullscreen
	update_display()

func update_display():
	window_mode_button.text = "FULLSCREEN" if OS.window_fullscreen else "WINDOWED"

func _on_back_button_pressed():
	# we have to perform two actions, so let's emit signal and modify there depending upon listener
	emit_signal("back_pressed")

func _on_music_volume_changed(volume_percentage):
	get_bus_volume_db("Music", volume_percentage)

func _on_sfx_volume_changed(volume_percentage):
	get_bus_volume_db("SFX", volume_percentage)

# our label value resets on every new instance, don't forget to call in _ready() to call and update on every instance
func update_voulme_label_display():
	# for Music label
	var music_volume_percentage = get_bus_volume_percentage("Music")
	music_range_control.set_volume_percentage(music_volume_percentage)

	# for SFX label
	var sfx_volume_percentage = get_bus_volume_percentage("SFX")
	sfx_range_control.set_volume_percentage(sfx_volume_percentage)
	
func get_bus_volume_db(bus_name, volume_percentage):
	# get bus idx
	var bus_idx = AudioServer.get_bus_index(bus_name)
	# convert linear percentage to db
	var volume_db = linear2db(volume_percentage)
	# setting bus volume db
	AudioServer.set_bus_volume_db(bus_idx, volume_db)

func get_bus_volume_percentage(bus_name):
	# get bus idx
	var bus_idx = AudioServer.get_bus_index(bus_name)
	# convert db to linear
	var volume_percentage = db2linear(AudioServer.get_bus_volume_db(bus_idx))
	return volume_percentage
