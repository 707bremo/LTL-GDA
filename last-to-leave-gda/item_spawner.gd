extends Node3D


@export var item_scene: PackedScene  # Assign a PackedScene in the Inspector
@export var spawn_area: Vector3 = Vector3()  # Define spawn area size

func spawn_items(item_count: int, loot_table: Array):
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
		add_child.call_deferred(item)


func _on_loot_tables_updated(loot_tables):
	spawn_items(20, loot_tables["civilian_food"])  # Spawn 5 civilian food items
