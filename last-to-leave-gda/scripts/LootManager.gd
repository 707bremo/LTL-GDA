extends Node

var loot_table = {}

func _ready():
	load_csv("res://loot_tables/LootTablesWeapons.csv")

func load_csv(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var lines = content.split("\n", false)  # False avoids empty extra lines
		if lines.size() < 2:
			print("Error: CSV is empty or has no data.")
			return
		
		var headers = lines[0].split(",")  # Read the column headers

		for i in range(1, lines.size()):
			if lines[i].strip_edges() == "":  # Skip empty lines
				continue

			var values = lines[i].split(",")
			if values.size() == headers.size():
				var item_data = {}
				for j in range(headers.size()):
					var value = values[j].strip_edges()
					
					# Convert to numbers where necessary
					if headers[j] in ["Weight", "Damage"]:  
						value = float(value)
					
					item_data[headers[j]] = value
				
				loot_table[values[0]] = item_data  # Store by item name or ID

		file.close()
		print("Loot table loaded successfully:", loot_table)
	else:
		print("Error loading CSV file!")


func get_random_loot():
	var total_weight = 0
	var weighted_items = []

	# Collect items & calculate total weight
	for item in loot_table.values():
		var weight = int(item["Weight"])  # Convert weight to number
		total_weight += weight
		weighted_items.append({"item": item, "weight": total_weight})

	# Generate a random number within total weight
	var roll = randf() * total_weight  

	# Find which item matches the random roll
	for entry in weighted_items:
		if roll < entry["weight"]:
			return entry["item"]  # Return the selected item
	
	return null  # Just in case
