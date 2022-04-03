extends Button

export var disable_hover: bool = false

func _ready():
	if not disable_hover:
		connect("mouse_entered", self, "_on_mouse_entered")
		connect("mouse_exited", self, "_on_mouse_exited")
	connect("pressed", self, "_on_pressed")
	connect("focus_exited", self, "_on_focus_exited")

func _on_mouse_entered():
	$HoverAnimationPlayer.play("hover") # grows

func _on_mouse_exited():
	reset_button_state()

func _on_focus_exited():
	reset_button_state()
	
func reset_button_state():
	$HoverAnimationPlayer.play_backwards("hover") # reset it's size

func _on_pressed():
	$ClickAnimationPlayer.play("click")
