extends Weapon

@export var fire_rate := 4.0

@onready var _cooldown_timer: Timer = %CooldownTimer


func _ready() -> void:
	super()
	_cooldown_timer.wait_time = 1.0 / fire_rate


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("shoot") and _cooldown_timer.is_stopped():
		shoot()


func shoot() -> void:
	_cooldown_timer.start()

	var bullet: Node = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	bullet.global_transform = global_transform
	bullet.max_range = max_range
	bullet.speed = max_bullet_speed
	bullet.rotation += randf_range(-random_angle / 2.0, random_angle / 2.0)

	audio_stream_player.play()
