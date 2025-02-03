extends Control

@onready var csv_path: LineEdit = $PanelContainer/VBoxContainer/VBoxContainer2/LineEdit
@onready var item_path: LineEdit = $PanelContainer/VBoxContainer/VBoxContainer3/LineEdit
@onready var table_path: LineEdit = $PanelContainer/VBoxContainer/VBoxContainer3/LineEdit2
@onready var prefab_path: LineEdit = $PanelContainer/VBoxContainer/VBoxContainer4/LineEdit
@onready var sprite_path: LineEdit = $PanelContainer/VBoxContainer/VBoxContainer4/LineEdit2
@onready var audio_path: LineEdit = $PanelContainer/VBoxContainer/VBoxContainer4/LineEdit3
@onready var event_path: LineEdit = $PanelContainer/VBoxContainer/VBoxContainer4/LineEdit4

@onready var clear_file_paths: Button = $PanelContainer/VBoxContainer/VBoxContainer/ClearFilePaths
@onready var auto_fill_paths: Button = $PanelContainer/VBoxContainer/VBoxContainer/AutoFillPaths
@onready var generate_loot: Button = $PanelContainer/VBoxContainer/VBoxContainer/GenerateLoot

@onready var csv_path_field = $PanelContainer/VBoxContainer/VBoxContainer2/LineEdit
@onready var table_container = $PanelContainer/VBoxContainer/VBoxContainer3/LineEdit2



var csv_data = []


func _ready():
	clear_file_paths.pressed.connect(_clear_paths)
	auto_fill_paths.pressed.connect(_auto_fill_paths)
	generate_loot.pressed.connect(_generate_loot)

func _clear_paths():
	csv_path.text = ""
	item_path.text = ""
	table_path.text = ""
	prefab_path.text = ""
	sprite_path.text = ""
	audio_path.text = ""
	event_path.text = ""

func _auto_fill_paths():
	# Example: Set default paths (modify as needed)
	csv_path.text = "res://data/database.csv"
	item_path.text = "res://data/items.csv"
	table_path.text = "res://data/tables.csv"
	prefab_path.text = "res://data/prefabs/"
	sprite_path.text = "res://data/sprites/"
	audio_path.text = "res://data/audio/"
	event_path.text = "res://data/events/"

func _generate_loot():
	print("Generating loot from:", csv_path.text)
	# Add CSV processing here




# Called when the "Auto-Fill Paths" button is pressed
func _on_auto_fill_paths_pressed():
	csv_path_field.text = "res://WeaponsDatabase.csv"

# Called when "Generate Loot" is pressed
func _on_generate_loot_pressed():
	if csv_path_field.text.is_empty():
		print("No CSV file selected!")
		return
	
	var file_path = csv_path_field.text
	if not FileAccess.file_exists(file_path):
		print("CSV file not found:", file_path)
		return
	
	load_csv(file_path)
	populate_table()

# Load CSV file and parse data
func load_csv(file_path):
	csv_data.clear()
	var file = FileAccess.open(file_path, FileAccess.READ)
	while not file.eof_reached():
		var line = file.get_line()
		var values = line.split(",")  # Split CSV by commas
		if values.size() > 1:  # Ensure it's a valid row
			csv_data.append(values)
	file.close()
	print("CSV Loaded Successfully!", csv_data)

# Populate UI dynamically
func populate_table():
	# Clear previous entries
	for child in table_container.get_children():
		child.queue_free()

	# Create rows for each CSV entry
	for row in csv_data:
		var hbox = HBoxContainer.new()
		for value in row:
			var label = Label.new()
			label.text = value
			hbox.add_child(label)
		table_container.add_child(hbox)
