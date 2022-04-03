extends Node2D

export (String, MULTILINE) var text

func _ready():
	$PanelContainer/MarginContainer/HintLabel.text = text
	$Area2D.connect("area_entered", self, "_on_player_entered")
	$Area2D.connect("area_exited", self, "_on_player_exited")
	
	$PanelContainer.visible = false

func _on_player_entered(_area2d):
	$PanelContainer.visible = true
	$Sprite.frame = 1 # glowing 

func _on_player_exited(_area2d):
	$PanelContainer.visible = false
	$Sprite.frame = 0 # normal
