extends Node3D

@export var footstep_sounds : Array[AudioStreamMP3]
@export var ground_pos : Marker3D
@onready var player : CharacterBody3D = get_parent()



func _ready() -> void:
	player.step.connect(play_sound)
	
func play_sound():
	
	
	# create a new 3D audio player node for spatialized sound
	var audio_player : AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	
	
	var random_index : int = randi_range(0, footstep_sounds.size() - 1)
	
	# select a random sound from the exported array
	audio_player.stream = footstep_sounds[random_index]
	
	# alter footstep pitch for natural variation
	# added as a child of position node so it plays in that area
	# finished signal and destory func. are there to conserve memory
	audio_player.pitch_scale = randf_range(0.8, 1.2)
	ground_pos.add_child(audio_player)
	audio_player.play()
	audio_player.finished.connect(func destroy(): audio_player.queue_free())
		
		
		
