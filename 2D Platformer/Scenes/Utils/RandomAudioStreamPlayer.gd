extends Node

# logic : setting up no of audio to play at same time and picking random audio within a given children

export var number_of_audio_to_play: int = 2
export var enable_pitch_randomization: bool = true
export var min_pitch_scale: float = .9
export var max_pitch_scale: float = 1.1

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize() # to set different seed

func play_audios():
	var valid_nodes: Array = []
	
	# filtering already playing audio
	for stream_player in get_children():
		if not stream_player.playing:
			valid_nodes.append(stream_player)

	# picking random stream_player
	for i in number_of_audio_to_play:
		if not valid_nodes.size():
			break
		else:
			# randi_range() start & end inclusive
			var idx = rng.randi_range(0, valid_nodes.size() - 1)

			# setting random pitch before play()
			if enable_pitch_randomization:
				valid_nodes[idx].pitch_scale = rng.randf_range(min_pitch_scale, max_pitch_scale)
			
			valid_nodes[idx].play()

			# to avoid repetion of same random
			valid_nodes.remove(idx)

