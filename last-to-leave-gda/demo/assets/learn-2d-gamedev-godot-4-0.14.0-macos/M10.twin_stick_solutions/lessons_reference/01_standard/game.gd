extends Node2D

@onready var _invisible_walls: TileMapLayer = %InvisibleWalls
@onready var _finish_line: FinishLine = %FinishLine


func _ready() -> void:
	_invisible_walls.hide()

	_finish_line.body_entered.connect(func (body: Node) -> void:
		if body is not Player_01:
			return
		body.set_physics_process(false)
		_finish_line.pop_confettis()
	)
	_finish_line.confettis_finished.connect(
		get_tree().reload_current_scene
	)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		var window := get_window()
		if window.mode == Window.MODE_FULLSCREEN:
			window.mode = Window.MODE_WINDOWED
		else:
			window.mode = Window.MODE_FULLSCREEN
