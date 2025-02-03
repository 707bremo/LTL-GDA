extends Node

func _ready():
	var file_path = "res://WeaponsDatabase.csv"
	var loot_data = []
	
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		
		while not file.eof_reached():
			var line = file.get_line()
			if line.is_empty():  # Skip empty lines
				continue
				
			# Use regex to properly split while respecting quoted text
			var columns = parse_csv_line(line)
			loot_data.append(columns)
		
		file.close()
		print("CSV Loaded Successfully!")
		print(loot_data)  # Display parsed data
		
	else:
		print("File does not exist:", file_path)

# Function to properly split CSV lines while keeping quoted values intact
func parse_csv_line(line: String) -> Array:
	var regex = RegEx.new()
	regex.compile("(?:\"([^\"]*)\")|([^,]+)")
	
	var matches = regex.search_all(line)
	var result = []
	
	for match in matches:
		if match.strings[1]:  # If first capture group (inside quotes) exists
			result.append(match.strings[1])
		else:
			result.append(match.strings[2])
	
	return result
