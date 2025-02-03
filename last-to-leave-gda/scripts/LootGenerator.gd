extends Node

# Parameters for loot generation
@export var group_size_min: int = 2
@export var group_size_max: int = 5
@export var total_loot_groups: int = 10

var loot_table = []  # Stores parsed loot data

# Load loot table from CSV
func load_loot_table(file_path: String):
	loot_table.clear()
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		file.get_line()  # Skip header
		while not file.eof_reached():
			var line = file.get_line().split(",")
			if line.size() >= 3:
				loot_table.append({
					"Name": line[0],
					"Weight": float(line[1]),
					"Tier": line[2]
				})

# Function to generate loot groups
func generate_loot():
	var loot_groups = []
	
	for i in range(total_loot_groups):
		var group_size = randi_range(group_size_min, group_size_max)
		var loot_group = []
		
		for j in range(group_size):
			var item = get_random_item()
			if item:
				loot_group.append(item)

			loot_groups.append(loot_group)

	return loot_groups

# Function to randomly pick an item based on weight
func get_random_item():
	if loot_table.is_empty():
		return null

	var total_weight = 0
	for item in loot_table:
		total_weight += item["weight"]

	var roll = randf() * total_weight
	var cumulative = 0

	for item in loot_table:
		cumulative += item["weight"]
		if roll <= cumulative:
			return item

		return null  # Fallback

# Example usage
func _ready():
	load_loot_table("res://loot_table.csv")
	var loot = generate_loot()
	print(loot)
