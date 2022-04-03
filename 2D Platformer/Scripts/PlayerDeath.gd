extends KinematicBody2D

var velocity: Vector2 = Vector2.ZERO
var gravity: int = 1000

func _ready():
	if velocity.x > 0:
		$Visuals.scale.x = -1 # flips the sprite and particles 
	
	# matching selected character texture
	# loading Sprite frame path
	var texture = load($"/root/Helpers".player_animation)
	$Visuals/Sprite.texture = texture.get_frame("idle", 0)

func _process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		velocity.x = lerp(0, velocity.x, pow(2, -1 * delta))
