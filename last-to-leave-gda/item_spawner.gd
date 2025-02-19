extends Node3D


@export var item_scene: PackedScene  # Assign a PackedScene in the Inspector
@export var spawn_area: Vector3 = Vector3(0.4, 0.4, 0.4)  # Define spawn area size


func spawn_items(item_count: int, loot_table: Array, force_magnitude: float = 30.0):
	for i in range(item_count):
		
		# Randomly select an item from the loot_table
		var random_item = loot_table[randi() % loot_table.size()]
		
		 # Spawn the item
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


# Apply a random force to scatter the item
		if item.has_method("apply_central_impulse"):  # Check if the item has a physics body
			var direction = Vector3(
				randf_range(-1, 1),
				randf_range(-1, 1),
				randf_range(-1, 1)
			).normalized()
			item.apply_central_impulse(direction * force_magnitude)
		if item.has_method("set_item_data"):
			item.set_item_data(random_item)


func _on_loot_tables_updated(loot_tables):
	spawn_items(40, loot_tables["civilian_food"])  # Spawn 5 civilian food items
