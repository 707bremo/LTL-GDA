extends CharacterBody3D

var speed=50

func _ready() -> void:
	add_to_group("bullet")

func _process(delta):
	position+=transform.basis * Vector3(0,0,-speed) * delta	
