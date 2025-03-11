extends Node3D
const SPEED = 30.0
@onready var mesh = $MeshInstance3D
@onready var ray =  $RayCast3D
@onready var particles = $GPUParticles3D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	if ray.is_colliding():
		mesh.visible = false
		particles.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
