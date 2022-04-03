extends Character

enum State { NORMAL, DASHING, DISABLE_INPUTS }

signal died

# on dash we can hurt only by spikes
export (int, LAYERS_2D_PHYSICS) var dash_hazard_mask

var current_state = State.NORMAL
var is_new_state: bool = true
var hurt_box_mask = null
var has_double_jumped: bool = false
var has_dash: bool = true
var is_dead: bool = false
var fell_down_to_death: bool = false

const player_death_scene: PackedScene = preload("res://Scenes/PlayerDeath.tscn")
const foor_steps_particles: PackedScene = preload("res://Scenes/FootStepsParticles.tscn")


func _ready():
	# it same as connecting signal through node
	$HurtBox.connect("area_entered", self, "_on_hit")
	$AnimatedSprite.connect("frame_changed", self, "_on_animated_sprite_frame_changed")

	hurt_box_mask = $HurtBox.collision_mask
	
	$AnimatedSprite.flip_h = true if initial_direction == FACING_DIRECTION.RIGHT else false
	
	# getting animation from autoload
	var current_player_animation = $"/root/Helpers".player_animation
	update_animated_sprite_frames(current_player_animation)

func _process(delta): 
	# delta adjusts right resolution for all screens
	
	match current_state:
		State.NORMAL:
			process_normal(delta)
		State.DASHING:
			process_dash(delta)
		State.DISABLE_INPUTS:
			process_input_disabled(delta)
	is_new_state = false


func change_state(new_state):
	current_state = new_state
	is_new_state = true

func process_normal(delta):
	if is_new_state:
		$DashParticles.emitting = false

		$DashAttackArea/CollisionShape2D.disabled = true
		$HurtBox.collision_mask = hurt_box_mask # both spikes and enemy

	var input_vector: Vector2 = get_movement_vector()

	if input_vector.y < 0 and (is_on_floor() or not $CoyoteTimer.is_stopped() or has_double_jumped):
		velocity.y = input_vector.y * jump_speed

		if not is_on_floor() and $CoyoteTimer.is_stopped():
			$"/root/Helpers".apply_camera_shake(0.25)
			has_double_jumped = false
		$CoyoteTimer.stop() # if there is longer time period

	# += is rate of change of velocity
	velocity.x += input_vector.x * horizontal_acceleration * delta
	velocity.x = clamp(velocity.x, 
	-max_horizontal_speed, # min for left
	max_horizontal_speed) # max for right 
	
	# now for deaccelerating, implemeting frame rate independent lerp()
	if input_vector.x == 0:
		velocity.x = lerp(0, velocity.x, pow(2, -horizontal_deacceleration_per_frame * delta))
	
	# variable jump height
	if velocity.y < 0 and not Input.is_action_pressed("jump"):
		# push down faster cancelling jump height
		velocity.y += gravity * jump_termination_multiplier * delta
	else:
		velocity.y += gravity * delta

		if velocity.y > 700: # fall damage
			fell_down_to_death = true
	
	var was_on_floor = is_on_floor() # before move_and_slide
	# move_and_slide automatically multiplies with delta
	velocity = move_and_slide(velocity, Vector2.UP) # floor's normal
	# m_and_s returns some vector, when colliding velocity will be set to ZERO
	
	# after move_and_slide when jump, is_on_floor() changed
	if was_on_floor and not is_on_floor():
		$CoyoteTimer.start()

	# meaning in air and landed
	if not was_on_floor and is_on_floor() and not is_new_state:
		emit_footparticles(1.35)

	# double jump
	if is_on_floor():
		has_double_jumped = true
		has_dash = true
		
		if fell_down_to_death: # next landing after move_and_slide
			player_died()

	update_animations()
	
	# changing dash state
	if Input.is_action_just_pressed("dash") and has_dash:
		call_deferred("change_state", State.DASHING)
		# use call deffered else _process() will set bool value to false instantaneously
		has_dash = false

func process_dash(delta):
	if is_new_state: # waits call deferred action to finsh then it _process() sets bool to false
		# overwriting current velocity
		$DashParticles.emitting = true
		$DashStreamPlayer.play_audios()
		
		$"/root/Helpers".apply_camera_shake(0.5)

		$DashAttackArea/CollisionShape2D.disabled = false
		$HurtBox.collision_mask = dash_hazard_mask # only spikes

		$AnimatedSprite.play("jump")
		var input_vector: Vector2 = get_movement_vector()
		var facing_direction: int = 1
		
		if input_vector.x != 0: # when moving
			# used sign() for joystick movements by get_action_strength()
			facing_direction = sign(input_vector.x) # returns 1 or -1
		else: # no input
			facing_direction = 1 if $AnimatedSprite.flip_h else -1


		velocity = Vector2(max_dash_speed * facing_direction, 0) # y = 0 because we don't want our gravity to affect horizontal dash
	
	velocity = move_and_slide(velocity, Vector2.UP)

	# decaying dash speed
	velocity.x = lerp(0, velocity.x, pow(2, -8 * delta))

	# exiting dash state
	if abs(velocity.x) < min_dash_speed: # abs for left dash
		call_deferred("change_state", State.NORMAL)


func process_input_disabled(delta):
	if is_new_state: # we may use for different scenorios
		$AnimatedSprite.play("idle")
	
	# lerping existing velocity
	velocity.x = lerp(0, velocity.x, pow(2, -horizontal_deacceleration_per_frame * delta))
	# apply gravity if player wins in jump state
	velocity.y += gravity * delta
	move_and_slide(velocity, Vector2.UP)

func get_movement_vector():
	
	# only for calculating Input
	var input_vector: Vector2 = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = -1 if Input.is_action_just_pressed("jump") else 0
	return input_vector

func update_animations():
	var input_vector: Vector2 = get_movement_vector()
	
	if not is_on_floor():
		$AnimatedSprite.play("jump")
	elif input_vector.x != 0:
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")

	# flip the sprite
	if input_vector.x != 0:
		$AnimatedSprite.flip_h = true if input_vector.x > 0 else false
	# we have to flip sprite in motion else idle input_vector == 0 and return false

func disable_player_inputs():
	change_state(State.DISABLE_INPUTS)

func _on_hit(_area2d): # body
	$"/root/Helpers".apply_camera_shake(1)
	call_deferred("player_died") # area2d and physics

func player_died():
	if is_dead:
		return

	# per instance only one dead call as we have only one life
	is_dead = true 
	var player_dead_instance = player_death_scene.instance()

	# assigning existing velocity to lerp on death
	player_dead_instance.velocity = velocity

	get_parent().add_child_below_node(self, player_dead_instance)
	player_dead_instance.global_position = global_position
	
	emit_signal("died")

func _on_animated_sprite_frame_changed():
	if $AnimatedSprite.animation == "run":
		if $AnimatedSprite.frame == 1:
			emit_footparticles()

func emit_footparticles(scale= 1):
	var foot_steps = foor_steps_particles.instance()
	get_parent().add_child(foot_steps)
	foot_steps.scale = Vector2.ONE * scale # Vector(1, 1)
	foot_steps.global_position = global_position
	# this is the case why we want to set player feet to origin
	
	$FootStepsStreamPlayer.play_audios()

func update_animated_sprite_frames(character_animation):
	# don't forget to load(path)
	$AnimatedSprite.frames = load(character_animation)

