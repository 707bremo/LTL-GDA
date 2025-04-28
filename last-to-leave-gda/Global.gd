extends Node

var loaded_game_data = {
	"health": 100,
	"position": Vector3.ZERO
}

func save_game():
	var file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	file.store_var(loaded_game_data)
	file.close()

func load_game():
	if FileAccess.file_exists("user://savegame.save"):
		var file = FileAccess.open("user://savegame.save", FileAccess.READ)
		loaded_game_data = file.get_var()
		file.close()
	else:
		print("No save file found!")
