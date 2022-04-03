extends Position2D

# no need for now as we pick random direction
# enum DIRECTION {RIGHT, LEFT}

export (PackedScene) var enemy_scene
# var start_direction: Vector2 = Vector2.ZERO

var current_enemy_node: KinematicBody2D = null
var spawn_on_next_tick: bool = false

func _ready():
	$SpawnTimer.connect("timeout", self, "_on_timeout")
	call_deferred("spawn_enemy") # physics based action in non_process function

func spawn_enemy():
	current_enemy_node = enemy_scene.instance()
	
	if randf() > 0.5:
		current_enemy_node.start_direction = Vector2.RIGHT
	else:
		current_enemy_node.start_direction = Vector2.LEFT
	
	get_parent().add_child(current_enemy_node) # parent is enemy node in scene
	current_enemy_node.global_position = global_position

func check_enemy_state():
	if not is_instance_valid(current_enemy_node):
		if spawn_on_next_tick: # we don't want timer to end, when we kill enemy and spawn immediately
			spawn_enemy()
			spawn_on_next_tick = false
		else:
			spawn_on_next_tick = true

# we use timer to check instance valid and spawn enemy
func _on_timeout():
	check_enemy_state()
