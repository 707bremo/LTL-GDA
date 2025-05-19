extends Control

@onready var restart_button: Button = %RestartButton


func _ready() -> void:
	restart_button.grab_focus()


func _on_RestartButton_pressed() -> void:
	get_tree().change_scene_to_file("res://lessons_reference/02_extended/ui/game_over.tscn")


func _on_QuitButton_pressed() -> void:
	get_tree().quit()
