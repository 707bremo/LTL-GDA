extends Control
const NewGameScene := preload("res://world/test_room.tscn")

func _ready():
	pass

func resume_game():
	get_tree().paused = false
	hide()

func load_game():
	pass

func pause_game():
	get_tree().paused = true
	show()

func test_pause_menu():
	if Input.is_action_just_pressed("pause_game") and get_tree().paused == false:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pause_game()
	elif Input.is_action_just_pressed("pause_game") and get_tree().paused == true:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		resume_game()

func _process(delta: float) -> void:
	test_pause_menu()

func _on_load_game_pressed() -> void:
	pass

func _on_quit_game_pressed() -> void:
	get_tree().quit()

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_packed(NewGameScene)
