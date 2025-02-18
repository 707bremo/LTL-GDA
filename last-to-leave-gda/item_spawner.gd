extends Node3D


@export var item_scene: PackedScene  # Assign a PackedScene in the Inspector
@export var spawn_area: Vector3 = Vector3(2, 2, 2)  # Define spawn area size

func spawn_items(item_count: int):
	for i in range(item_count):
		var item = item_scene.instantiate()
		item.position = Vector3(
			randf_range(-spawn_area.x / 2, spawn_area.x / 2),
			randf_range(-spawn_area.y / 2, spawn_area.y / 2),
			randf_range(-spawn_area.z / 2, spawn_area.z / 2)
		)
		item.rotation = Vector3(
			randf_range(0, 360),
			randf_range(0, 360),
			randf_range(0, 360)
		)
		add_child(item)
