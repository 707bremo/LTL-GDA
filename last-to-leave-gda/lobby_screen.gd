extends Control

signal back

@onready var select_frame: TextureRect = $select_frame
@onready var scroll_select: AudioStreamPlayer = $"../SoundsNmoozic/scroll_select"

var play_position : Vector2 = Vector2(0, 616)
var controls_position : Vector2 = Vector2(0, 671)
var exit_position : Vector2 = Vector2(0, 726)



func _ready() -> void:
	select_frame.position = play_position

func _on_play_game_mouse_entered() -> void:
	select_frame.position = play_position
	scroll_select.play()

func _on_controls_button_mouse_entered() -> void:
	select_frame.position = controls_position
	scroll_select.play()

func _on_exit_button_mouse_entered() -> void:
	select_frame.position = exit_position
	scroll_select.play()
