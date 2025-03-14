extends Node3D
const SPEED = 30.0
const GRAVITY = -5.8  
var velocity = Vector3(0, 0, -SPEED) 

func _process(delta: float) -> void:
	velocity.y += GRAVITY * delta  
	position += transform.basis * velocity * delta  
