extends Node3D

@export var item_scene: PackedScene  # Assign a PackedScene in the Inspector
@export var spawn_count: int = 10  # Number of items to spawn
@export var explosion_force: float = 10.0  # Strength of the explosion

# Variables to store the room's bounding box
var room_min: Vector3
var room_max: Vector3
var room_center: Vector3

func _ready():
	# Calculate the room's bounding box
	calculate_bounding_box()
	# Spawn items within the room
	spawn_items_in_room(spawn_count)

# Calculate the room's bounding box
func calculate_bounding_box():
	# Get all MeshInstance3D nodes in the room
	var meshes = get_tree().get_nodes_in_group("room_meshes")
	if meshes.size() > 0:
		# Initialize min and max with the first mesh's AABB
		var aabb = meshes[0].get_aabb()
		room_min = aabb.position
		room_max = aabb.end
		# Iterate through the rest of the meshes to find the overall bounding box
		for mesh in meshes:
			aabb = mesh.get_aabb()
			room_min = room_min.min(aabb.position)
			room_max = room_max.max(aabb.end)
		# Calculate the median point (center) of the room
		room_center = (room_min + room_max) / 2
	else:
		print("No meshes found in the room. Please add MeshInstance3D nodes.")

# Spawn items randomly within the room
func spawn_items_in_room(item_count: int):
	for i in range(item_count):
		# Randomly select a position within the room's bounding box
		var position = Vector3(
			randf_range(room_min.x, room_max.x),
			randf_range(room_min.y, room_max.y),
			randf_range(room_min.z, room_max.z)
		)
		# Spawn the item
		var item = item_scene.instantiate()
		item.position = position
		item.rotation = Vector3(
			randf_range(0, 360),
			randf_range(0, 360),
			randf_range(0, 360)
		)
		add_child(item)

		# Apply a random force to scatter the item
		if item.has_method("apply_central_impulse"):
			var direction = Vector3(
				randf_range(-1, 1),
				randf_range(-1, 1),
				randf_range(-1, 1)
			).normalized()
			item.apply_central_impulse(direction * explosion_force)
