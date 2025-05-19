extends Weapon


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()


func shoot() -> void:
	var bullet: Node = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	bullet.global_transform = global_transform
	bullet.max_range = max_range
	bullet.speed = max_bullet_speed
	bullet.rotation += randf_range(-random_angle / 2.0, random_angle / 2.0)

	audio_stream_player.play()
