extends Node

# Adjustable parameters
var loot_size = 3  # Number of items per loot drop
var min_rarity = 0  # Minimum tier value allowed
var max_rarity = 10  # Maximum tier value allowed

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
		
		var headers = lines[0].strip_edges().replace("\r", "").split(",")  # Read the column headers

		for i in range(1, lines.size()):
			if lines[i].strip_edges() == "":  # Skip empty lines
				continue

			var line = lines[i].strip_edges()
			if line == "":
				continue  # Skip empty lines

			var values = line.replace("\r", "").split(",")
			if values.size() == headers.size():
				var item_data = {}
				for j in range(headers.size()):
					var value = values[j].strip_edges()
					
					# Convert to numbers where necessary
					if headers[j] in ["Weight", "Tier"]:  
						value = float(value)
					
					item_data[headers[j]] = value
				
				loot_table[values[0]] = item_data  # Store by item name or ID

		file.close()
		print("Loot table loaded successfully:", loot_table)
	else:
		print("Error loading CSV file!")


func get_random_loot_group():
	var total_weight = 0
	var weighted_items = []

	for item in loot_table.values(): 
		var tier = int(item["Tier"])
		if tier >= min_rarity and tier <= max_rarity:
			var weight = int(item["Weight"])
			total_weight += weight
			weighted_items.append({"item": item, "weight": total_weight})

# Ensure there are items to roll
	if total_weight == 0 or weighted_items.is_empty():
		print("No valid loot items found in the specified rarity range.")
		return []

	var loot_group = []
	
# Select multiple items
	for _i in range(loot_size):
		var roll = randf() * total_weight  # Roll within total weight
		
# Find which item matches the random roll
		for entry in weighted_items:
			if roll < entry["weight"]:
				loot_group.append(entry["item"])
				break

	return loot_group  # Return group of randomly selected loot items

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):  # Press Enter to test loot
		print("Generated Loot:", get_random_loot_group())
