extends Node
# no reload scene when player died, player is respawned

signal coin_total_changed

export (PackedScene) var level_complete_scene

const player_scene: PackedScene = preload("res://Scenes/Player.tscn")
const pause_menu_scene: PackedScene = preload("res://Scenes/UI/PauseMenu.tscn")

var spawn_position: Vector2 = Vector2.ZERO
var current_player_node = null
var total_coins: int
var collected_coins: int = 0

func _ready():
	spawn_position = $PlayerRoot/Player.global_position
	register_player($PlayerRoot/Player)
				   # returns array
	new_coin_total(get_tree().get_nodes_in_group("Coin").size())

	$Flag.connect("player_win", self, "_on_player_reached_goal")

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		var pause_instance = pause_menu_scene.instance()
		add_child(pause_instance)


func coin_collected():
	collected_coins += 1
	emit_signal("coin_total_changed", total_coins, collected_coins)

func new_coin_total(new_total): # what if we spawned coins for opening chest or defeating enemies
	total_coins = new_total
	emit_signal("coin_total_changed", total_coins, collected_coins)

func register_player(player):
	current_player_node = player
	current_player_node.connect("died", self, "_on_player_died", [], CONNECT_DEFERRED) # flag - physics based action

func create_player():
	var player_instance = player_scene.instance()
	$PlayerRoot.add_child(player_instance)
	player_instance.global_position = spawn_position
	register_player(player_instance)

func _on_player_died():
	current_player_node.queue_free()
	yield(get_tree().create_timer(1.5), "timeout")
	create_player()

func _on_player_reached_goal():
	current_player_node.disable_player_inputs() # player not to move
	var level_complete_ui = level_complete_scene.instance()
	add_child(level_complete_ui)
