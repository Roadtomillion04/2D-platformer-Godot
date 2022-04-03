extends Node2D

func _ready():
	# it same as connecting signal through node
	$Area2D.connect("area_entered", self, "_on_pickup")

func _on_pickup(_area2d): # body
	$AnimationPlayer.play("pickup")
	$CoinCollectStreamPlayer.play_audios()

	call_deferred("disable_pickup")
	
	# returns array
	var main = get_tree().get_nodes_in_group("Level")[0]
	main.coin_collected()

func disable_pickup():
	$Area2D/CollisionShape2D.disabled = true
	
