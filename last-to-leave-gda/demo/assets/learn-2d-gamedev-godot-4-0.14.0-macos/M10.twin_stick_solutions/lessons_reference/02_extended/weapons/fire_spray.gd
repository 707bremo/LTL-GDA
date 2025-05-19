extends Weapon

@export_range(100.0, 2000.0, 1.0) var min_range := 200.0
@export_range(100.0, 3000.0, 1.0) var min_bullet_speed := 800.0

@export_range(1, 30) var min_amount := 6
@export_range(1, 30) var max_amount := 9

@onready var _cooldown_timer: Timer = %CooldownTimer


func _init() -> void:
	assert(min_range < max_range)
	assert(min_bullet_speed < max_bullet_speed)
	assert(min_amount < max_amount)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and _cooldown_timer.is_stopped():
		shoot()


func shoot() -> void:
	_cooldown_timer.start()

	var bullet_count := randf_range(min_amount, max_amount + 1)

	for i in bullet_count:
		var bullet := bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)

		bullet.global_transform = global_transform
		bullet.max_range = randf_range(min_range, max_range)
		bullet.speed = randf_range(min_bullet_speed, max_bullet_speed)
		bullet.rotation += randf_range(-random_angle / 2.0, random_angle / 2.0)

	audio_stream_player.play()
