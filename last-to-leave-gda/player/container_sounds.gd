extends Node3D

@export_category("Arrays")
@export var container_sounds : Array[AudioStreamMP3]
@export var container_detector : RayCast3D
@onready var player : CharacterBody3D = get_parent()



func _ready() -> void:
	player.opening_container.connect(play_sound)
	
func play_sound():
	
	
	# pick a random sound from the given array
	# get the collider of the container_detector raycast so identify material
	# create a new 3D audio player node for spatialized sound
	var collider = container_detector.get_collider()
	var audio_player : AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	
	if container_detector.is_colliding():
		if collider.is_in_group("cabinet"):
			# select the coressponding sound from the exported array
			audio_player.stream = container_sounds[0]
			print("opened cabinet")
			# will assign a random sound soon, still need more sounds
		
		# no sound or collider for metal yet, so pass
	if container_detector.is_colliding():
		if collider.is_in_group("fridge"):
			pass
	
	if container_detector.is_colliding():
		if collider.is_in_group("tent") and Input.is_action_just_pressed("interact"):
			audio_player.stream = container_sounds[2]
			print("opened tent")
			
			
	# alter footstep pitch for natural variation
	# added as a child of position node so it plays in that area
	# finished signal and destory func. are there to conserve memory
	audio_player.pitch_scale = randf_range(0.8, 1.5)
	player.add_child(audio_player)
	audio_player.play()
	audio_player.finished.connect(func destroy(): audio_player.queue_free())
