## Base class for enemies. Defines some functions you can reuse to create
## different kinds of enemies.
class_name Mob_01 extends CharacterBody2D

@export var damage := 1
@export var max_health := 3
@export var max_speed := 250.0
@export var acceleration := 700.0

var health := max_health: set = set_health

var _player: Player_01 = null

@onready var _detection_area: Area2D = %DetectionArea
@onready var _hit_box: Area2D = %HitBox
@onready var _die_sound: AudioStreamPlayer2D = %DieSound


func _ready() -> void:
	set_health(max_health)
	_detection_area.body_entered.connect(func (body: Node) -> void:
		if body is Player_01:
			_player = body
	)
	_detection_area.body_exited.connect(func (body: Node) -> void:
		if body is Player_01:
			_player = null
	)
	_hit_box.body_entered.connect(func (body: Node) -> void:
		if body is Player_01:
			body.health -= damage
	)


func set_health(new_health: int) -> void:
	health = clampi(new_health, 0, max_health)
	if health == 0:
		die()


func die() -> void:
	# We remove anything that can trigger collisions again and leave the monster
	# as an invisible wall.
	_hit_box.queue_free()
	collision_layer = 0
	collision_mask = 0
	set_process(false)
	set_physics_process(false)

	_die_sound.pitch_scale = randf_range(0.95, 1.05)
	_die_sound.play()
	_die_sound.finished.connect(queue_free)


func _physics_process(delta: float) -> void:
	if _player == null:
		return

	var direction := global_position.direction_to(_player.global_position)
	var distance := global_position.distance_to(_player.global_position)
	var speed := max_speed if distance > 120.0 else max_speed * distance / 120.0
	var desired_velocity := direction * speed
	velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	move_and_slide()
