extends Area3D

@export var connect_portal: Node3D

func _on_body_entered(body: CharacterBody3D) -> void:
	if body.is_in_group("player"):
		var destination = connect_portal.global_transform.origin
		body.global_transform.origin = destination
		print("EnteredPortal")
