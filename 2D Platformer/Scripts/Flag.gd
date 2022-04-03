extends Node2D

signal player_win

func _ready():
	$Area2D.connect("area_entered", self, "_on_entered")

func _on_entered(_area2d):
	emit_signal("player_win")
	$Particles2D.emitting = true
	$AudioStreamPlayer.play()
