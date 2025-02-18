# DataHandler.gd +++
extends Node

signal loot_tables_updated(loot_tables)
var item_data := {}
#var item_grid_data := {}

var loot_tables = {
	"civilian_food": [],
	"military_gear": []
}

@onready var item_data_path = "res://data/loot_table_food/LTL-DATASHEET - C_FOOD_ITEM_DATA.csv"


# Get the data ready according to the file being summoned.
func _ready() -> void:
	load_items_from_csv(item_data_path)
	populate_loot_tables()
	print("Loot Tables: ", loot_tables)
	#set_grid_data()

func load_items_from_csv(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var header = file.get_csv_line()  # Skip header
		while not file.eof_reached():
			var line = file.get_csv_line()
			if line.size() > 0:
				var item = {
					"id": line[0],
					"name": line[1],
					 "type": line[2],
					"description": line[3],
					"abbreviation": line[4],
					"volume": float(line[5]),
					"weight": float(line[6]),
					"rarity": line[7],
				}
				item_data[line[0]] = item
		file.close()
	else:
		print("Failed to open file: ", file_path)

func populate_loot_tables():
	for item in item_data.values():
		if item["type"] == "Consumables" and item["rarity"] == "Common":
			loot_tables["civilian_food"].append(item)
		elif item["type"] == "Weapon":
			loot_tables["military_gear"].append(item)
	emit_signal("loot_tables_updated", loot_tables)




#func set_grid_data():
	#for item in item_data.keys():
		#var temp_grid_array := []
		#for point in item_data[item]["Volume"].split("/"):
			#temp_grid_array.push_back(point.split(","))
		#item_grid_data[item] = temp_grid_array
	#print(item_grid_data)
