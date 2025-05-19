extends Control

var _start_time := Time.get_ticks_msec()

@onready var _time_label: Label = %TimeLabel

@onready var _replay_button: Button = %ReplayButton
@onready var _quit_button: Button = %QuitButton

@onready var _color_rect: ColorRect = %ColorRect
@onready var _panel_container: PanelContainer = %PanelContainer


func _ready() -> void:
	visible = false
	_replay_button.pressed.connect(func () -> void:
		get_tree().paused = false
		get_tree().reload_current_scene()
	)
	_quit_button.pressed.connect(get_tree().quit)


func animate_progress(amount := 0.0) -> void:
	_color_rect.material.set_shader_parameter("blur_amount", lerp(0.0, 1.5, amount))
	_color_rect.material.set_shader_parameter("tint_strength", lerp(0.0, 0.25, amount))
	_panel_container.modulate.a = amount


func open() -> void:
	visible = true
	get_tree().paused = true

	var end_time := Time.get_ticks_msec()
	var total_time_msec := end_time - _start_time
	var total_time_s := total_time_msec / 1000
	_time_label.text = "Time: " + str(total_time_s) + "s"
	
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_method(animate_progress, 0.0, 1.0, 0.5)
	
	pop_confettis()


## Emitted when the confettis finish popping.
signal confettis_finished

@export_group("Confettis", "confettis_")
## Determines how many confettis get popped when calling [method pop_confettis].
@export var confettis_amount := 5
## Determines a radius within which random confetti emitters will spawn when
## calling [method pop_confettis].
@export var confettis_radius := 128.0
## Determines the timing between different confetti emitter popping when calling
## [method pop_confettis].
@export var confettis_pop_time_delay := 0.5


## Creates a few confetti emitters in random areas in the given radius and pops
## them in a staggered manner, then calls [signal finished].
func pop_confettis() -> void:
	var viewport_size := get_viewport_rect().size
	for _i in confettis_amount:
		await get_tree().create_timer(confettis_pop_time_delay).timeout

		var confettis: GPUParticles2D = preload("res://common/particles/confettis/confettis.tscn").instantiate()
		add_child(confettis)
		
		confettis.global_position = Vector2(
			randf_range(0.0, viewport_size.x),
			viewport_size.y
		)
		confettis.emitting = true

	await get_tree().create_timer(2.0).timeout
	confettis_finished.emit()
