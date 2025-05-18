extends Node3D

signal door_interacted

@onready var anim_player: AnimationPlayer = $AnimationPlayer

var is_open = false

func interact():
	print("Door was interacted with!")
	emit_signal("door_interacted")
	
	if is_open:
		anim_player.play("close")
		is_open = false
	else:
		anim_player.play("open")
		is_open = true
