extends Control



func _ready():
	$blurAnim.play("RESET")
	hide()


func resume_game():
	get_tree().paused = false
	$blurAnim.play_backwards("blurmenu")
	hide()

func load_game():
	pass

func pause_game():
	get_tree().paused = true
	$blurAnim.play("blurmenu")
	show()

func test_pause_menu():
	if Input.is_action_just_pressed("pause_game") and get_tree().paused == false:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pause_game()
	elif Input.is_action_just_pressed("pause_game") and get_tree().paused == true:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		resume_game()

func _on_continue_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	resume_game()

func _on_load_pressed() -> void:
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	get_tree().quit()


func _process(delta: float) -> void:
	test_pause_menu()
