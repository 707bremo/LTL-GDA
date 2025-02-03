extends Node3D

@onready var spawn_point = $Marker3D
@onready var generate_button = $CanvasLayer/Button

var loot_system = preload("res://scripts/LootManager.gd").new()  # Load loot system
var loot_scene = preload("res://loot_item.tscn")  # Load the 3D loot scene

func _ready():
	generate_button.pressed.connect(spawn_loot)  # Connect button to function
	loot_system.load_csv("res://loot_tables/LootTablesWeapons.csv")  # Load loot table

func spawn_loot():
	var loot_group = loot_system.get_random_loot_group()  # Get multiple items
	if loot_group.is_empty():
		print("⚠ No loot was generated.")
		return

	for loot in loot_group:  # Loop through each loot item
		var loot_instance = loot_scene.instantiate()
		loot_instance.transform.origin = spawn_point.transform.origin

		if "Tier" not in loot:
			print("🚨 ERROR: 'Tier' key is missing! Dictionary contains:", loot)

# Set loot name on the 3D label
		var label = loot_instance.get_node("MeshInstance3D/Label3D")
		label.text = loot.get("Name", "Unknown") + " (" + str(loot.get("Tier", "Unknown")) + ")"

		add_child(loot_instance)  # Spawn loot in the scene
