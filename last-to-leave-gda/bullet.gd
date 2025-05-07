extends Area3D

@export var speed: float = 30.0
var target: CharacterBody3D

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _process(delta: float) -> void:
	if target and target.is_inside_tree():
		var direction = (target.global_position - global_position).normalized()
		global_position += direction * speed * delta
		look_at(target.global_position, Vector3.UP)

func _on_body_entered(body: Node) -> void:
	queue_free()  # Remove the bullet
