class_name Teleporter extends Area2D

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


func _ready() -> void:
	body_entered.connect(func (body: Node) -> void:
		if body is Player:
			body.set_physics_process(false)
			pop_confettis()
	)


## Creates a few confetti emitters in random areas in the given radius and pops
## them in a staggered manner, then calls [signal finished].
func pop_confettis() -> void:
	for _i in confettis_amount:
		await get_tree().create_timer(confettis_pop_time_delay).timeout

		var confettis: GPUParticles2D = preload("res://common/particles/confettis/confettis.tscn").instantiate()
		add_child(confettis)
		confettis.global_position = global_position + Vector2.from_angle(randf() * TAU) * confettis_radius
		confettis.emitting = true

	await get_tree().create_timer(2.0).timeout
	confettis_finished.emit()
