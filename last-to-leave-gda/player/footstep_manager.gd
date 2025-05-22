extends Node3D

@export_category("Footstep Arrays")
@export var dirt_footstep_sounds : Array[AudioStreamMP3]
@export var wood_footstep_sounds : Array[AudioStreamMP3]
@export var metal_footstep_sounds : Array[AudioStreamMP3]
@export var concrete_footstep_sounds : Array[AudioStreamMP3]
@export var ground_pos : Marker3D
@export var floor_detector : RayCast3D
@onready var player : CharacterBody3D = get_parent()



func _ready() -> void:
	player.step.connect(play_sound)
	
func play_sound():
	
	
	# pick a random sound from the given array
	# get the collider of the floor_detector raycast so identify material
	# create a new 3D audio player node for spatialized sound
	var w_random_index : int = randi_range(0, wood_footstep_sounds.size() - 1)
	var collider = floor_detector.get_collider()
	var audio_player : AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	
	if floor_detector.is_colliding():
		if collider.is_in_group("grass"):
			# select the coressponding sound from the exported array
			audio_player.stream = dirt_footstep_sounds[0]
			print("stepping on dirt")
			# will assign a random sound soon, still need more sounds
		
	if floor_detector.is_colliding():
		if collider.is_in_group("metal"):
			audio_player.stream = metal_footstep_sounds[0]
			print("stepping on metal")
	
	if floor_detector.is_colliding():
		if collider.is_in_group("wood"):
			audio_player.stream = wood_footstep_sounds[w_random_index]
			print("stepping on wood")
			
			
	# alter footstep pitch for natural variation
	# added as a child of position node so it plays in that area
	# finished signal and destory func. are there to conserve memory
	audio_player.pitch_scale = randf_range(0.8, 1.5)
	ground_pos.add_child(audio_player)
	audio_player.play()
	audio_player.finished.connect(func destroy(): audio_player.queue_free())
