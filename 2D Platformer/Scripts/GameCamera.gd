extends Camera2D

var target_position: Vector2 = Vector2.ZERO
var camera_pos_x
var camera_pos_y

export var constant_frame: int = 20
export (OpenSimplexNoise) var shake_noise

# OpenSimpleNoise
# direction
var x_noise_sample_vector: Vector2 = Vector2.RIGHT
var y_noise_sample_vector: Vector2 = Vector2.DOWN

# position
var x_noise_sample_position: Vector2 = Vector2.ZERO
var y_noise_sample_position: Vector2 = Vector2.ZERO

# speed 
var noise_sample_travel_rate: int = 1500
var max_shake_offset: int = 30
var current_shake_percentage: float = 0
var shake_decay: int = 3 # 300% for 100% shake percentage means .5 sec

func _process(delta):
	accquire_target_position()
	
	camera_pos_x = int(lerp(target_position.x, global_position.x, pow(2, -constant_frame * delta)))
	camera_pos_y = int(lerp(target_position.y, global_position.y, pow(2, -constant_frame * delta)))
	
	global_position = Vector2(camera_pos_x, camera_pos_y)
	
	# OpenSimpleNoise
	if current_shake_percentage > 0:
		# shifting right and down by travel rate pixels per sec
		x_noise_sample_position += x_noise_sample_vector * noise_sample_travel_rate * delta
		y_noise_sample_position = y_noise_sample_vector * noise_sample_travel_rate * delta
		# sample noise                 returns values from [-1, 1]
		var x_sample: float = shake_noise.get_noise_2d(x_noise_sample_position.x, x_noise_sample_position.y)
		var y_sample: float = shake_noise.get_noise_2d(y_noise_sample_position.x, y_noise_sample_position.y)
		
		var calculated_offset: Vector2 = Vector2(x_sample, y_sample) * max_shake_offset * pow(current_shake_percentage, 2)
		
		# camera offset
		self.offset = calculated_offset
		
		# decay shake for limited time
		current_shake_percentage = clamp(current_shake_percentage - shake_decay * delta, 0, 1)

func apply_shake(percentage):
	current_shake_percentage = clamp(current_shake_percentage + percentage, 0, 1)

func accquire_target_position():
	# gets all player group return array
	var acquired = get_target_position_from_node_group("Player")
	if not acquired: # means player dead
		get_target_position_from_node_group("PlayerDead")

func get_target_position_from_node_group(group_name):
	var nodes = get_tree().get_nodes_in_group(group_name)
	if nodes.size() > 0: # not empty
		var node = nodes[0] # as we have one player
		target_position = node.global_position
		return true
	else:
		return false

# we are not setting to camera pos, when player is not dead in game we can assign last target pos to camera pos
