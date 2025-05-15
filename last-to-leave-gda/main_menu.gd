extends Control


# ALL UI ELEMENTS
@onready var menu_player = $MenuPlayer
@onready var menu_music: AudioStreamPlayer = $SoundsNmoozic/MenuMusic
@onready var play_button : Button = $play
@onready var transfer_screen_blocker: Control = $transfer_screen
@onready var bg: ColorRect = $bg
@onready var siimlogo: Sprite2D = $siimlogo
@onready var title: Label = $title
@onready var lobby_screen: Control = $lobby_screen
@onready var play_game_button: Button = $lobby_screen/play_game
@onready var selection_bg: ColorRect = $lobby_screen/selection_bg


# conditions ONLY for screen verification
var is_start_screen : bool = true
var is_lobby_screen : bool = true



func _ready() -> void:
	Input.MOUSE_MODE_VISIBLE
	is_start_screen = true
	is_lobby_screen = false
	menu_music.play()
	menu_player.play("main_opening")



func _process(delta: float) -> void:
	
	
# press the enter button to transfer from the start, to the lobby
	if Input.is_action_just_pressed("ui_accept") and is_start_screen:
		is_start_screen = false
		play_button.emit_signal("pressed")
		$SoundsNmoozic/main_select.play()
	



func transfer_screen():
	menu_player.play("transfer_to_lobby")

func stop_transfer(anim_name: StringName) -> void:
	if anim_name == "transfer_to_lobby":
		lobby_screen.visible = true
		is_lobby_screen = true
		play_button.disabled = true
		title.visible = false
		siimlogo.visible = false
		play_button.visible = false
		menu_player.play("lobby_opening")


	if anim_name == "selected":
		selection_bg.visible = false
		transfer_to_game()



func play_game_pressed():
	$SoundsNmoozic/main_select.play()
	selection_bg.visible = true
	menu_player.play("selected")


func transfer_to_game():
	LoadingScreenFunctions.load_screen_to_scene("res://world/test_room.tscn")
