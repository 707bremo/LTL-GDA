extends Control


func resume_game():
	get_tree().paused = false
	$blurAnim.play_backwards("blurmenu")

func load_game():
	pass

func pause_game():
	get_tree().paused = true
	$blurAnim.play("blurmenu")

func test_pause_menu():
	if Input.is_action_just_pressed("pause_game") and get_tree().paused == false:
		pause_game()
	elif Input.is_action_just_pressed("pause_game") and get_tree().paused == true:
		resume_game()

func _on_continue_pressed() -> void:
	resume_game()

func _on_load_pressed() -> void:
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	get_tree().quit()
