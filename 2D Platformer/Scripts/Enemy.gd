extends Character

# to be handled by animation_player in property track
export var is_spawnig_on_instance: bool = true

const enemy_death_scene: PackedScene = preload("res://Scenes/EnemyDeath.tscn")

var direction: Vector2 = Vector2.ZERO
var start_direction: Vector2 = Vector2.ZERO

func _ready():
	# it same as connecting signal through node
	$PathFinder.connect("area_entered", self, "_on_goal_entered")
	$HurtBox.connect("area_entered", self, "_on_hit")
	
	# different values for all enemies
	max_horizontal_speed = 25
	jump_speed = 325
	
	direction = start_direction

func _process(delta):
	if is_spawnig_on_instance:
		return # after spawning animation finished we set it to false

	velocity.x = max_horizontal_speed * direction.x

	velocity.y += gravity * delta

	velocity = move_and_slide(velocity, Vector2.UP)
	
	# no change in motion required since there is no idle
	$Visuals/AnimatedSprite.flip_h = true if direction.x > 0 else false 

func _on_goal_entered(area2d):
	if area2d.collision_layer == 16: # direction changer
		direction *= -1 # reverse the vector
	elif area2d.collision_layer == 128: # jump helper
		velocity.y = -jump_speed

func _on_hit(_area2d):
	$"/root/Helpers".apply_camera_shake(1)
	call_deferred("enemy_dead")

func enemy_dead():
	var death_instance = enemy_death_scene.instance()
	get_parent().add_child(death_instance) # adds in enemy node
	death_instance.global_position = global_position
	
	 # flipping sprite upon facing direction
	death_instance.scale.x = -1 if velocity.x > 0 else 1

	queue_free()

