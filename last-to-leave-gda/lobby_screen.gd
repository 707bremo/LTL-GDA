extends Control

signal back

# frame variables
@onready var select_frame: TextureRect = $select_frame
@onready var scroll_select: AudioStreamPlayer = $"../SoundsNmoozic/scroll_select"
@onready var instructions: AnimationPlayer = $instructions
@onready var looping_weapons: AnimationPlayer = $looping_weapons

# label variables
@onready var play_label: Label = $Label
@onready var controls_label_2: Label = $Label2
@onready var exit_label_3: Label = $Label3


var play_position : Vector2 = Vector2(0, 616)
var controls_position : Vector2 = Vector2(0, 671)
var exit_position : Vector2 = Vector2(0, 726)



func _ready() -> void:
	select_frame.position = play_position

func _on_play_game_mouse_entered() -> void:
	play_label.visible = true
	select_frame.position = play_position
	instructions.play("scroll_instructions")
	scroll_select.play()

func _on_play_game_mouse_exited() -> void:
	play_label.visible = false
	instructions.play_backwards("scroll_instructions")

func _on_controls_button_mouse_entered() -> void:
	controls_label_2.visible = true
	select_frame.position = controls_position
	instructions.play("scroll_instructions2")
	scroll_select.play()

func _on_controls_button_mouse_exited() -> void:
	controls_label_2.visible = false
	instructions.play_backwards("scroll_instructions2")

func _on_exit_button_mouse_entered() -> void:
	exit_label_3.visible = true
	select_frame.position = exit_position
	instructions.play("scroll_instructions3")
	scroll_select.play()

func _on_exit_button_mouse_exited() -> void:
	exit_label_3.visible = false
	instructions.play("scroll_instructions3")
