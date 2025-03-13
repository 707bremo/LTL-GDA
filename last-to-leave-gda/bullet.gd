extends Node3D
const SPEED = 30.0
const GRAVITY = -9.8  
@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
@onready var particles = $GPUParticles3D
var velocity = Vector3(0, 0, -SPEED) 

func _process(delta: float) -> void:
	velocity.y += GRAVITY * delta  
	position += transform.basis * velocity * delta  
	if ray.is_colliding():
		mesh.visible = false
		particles.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()
