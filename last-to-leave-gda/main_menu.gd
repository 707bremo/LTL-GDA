extends Control

@onready var menu_player = $MenuPlayer
@onready var menu_music: AudioStreamPlayer = $SoundsNmoozic/MenuMusic


func _ready() -> void:
	menu_music.play()
	menu_player.play("main_opening")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		$SoundsNmoozic/main_select.play()
