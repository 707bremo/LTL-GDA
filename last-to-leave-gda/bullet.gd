extends Area3D

@export var speed: float = 30.0
var direction: Vector3 = Vector3.ZERO
signal player_hit

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _process(delta: float) -> void:
	if direction != Vector3.ZERO:
		global_position += direction * speed * delta
		look_at(global_position + direction, Vector3.UP)

func _on_body_entered(body: CharacterBody3D) -> void:
	if body is CharacterBody3D:
		queue_free()
