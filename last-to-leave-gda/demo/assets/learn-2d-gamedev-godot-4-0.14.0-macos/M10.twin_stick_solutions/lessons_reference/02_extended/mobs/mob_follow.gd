# Mob that follows the _player and deals a close combat attack.
extends Mob

@onready var _timer: Timer = %CooldownTimer
@onready var _attack_hit_box: Area2D = %AttackHitBox
@onready var _sprite_2d: Sprite2D = %Sprite2D
@onready var _sprite_pivot: Node2D = %SpritePivot


func _ready() -> void:
	super()
	_timer.one_shot = true
	_attack_hit_box.body_entered.connect(func (body: Node) -> void:
		if body is Player:
			body.health -= damage
	)


func _physics_process(delta: float) -> void:
	if _player == null:
		return

	var direction := global_position.direction_to(_player.global_position)
	var distance := global_position.distance_to(_player.global_position)
	var speed := max_speed if distance > 120.0 else max_speed * distance / 120.0
	var desired_velocity := direction * speed
	velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	move_and_slide()

	if not animation_player.is_playing():
		_sprite_2d.look_at(_player.global_position)

	if _timer.is_stopped() and distance < 120.0:
		animation_player.play("attack")
		_sprite_pivot.scale.x = -1.0 if direction.x < 0.0 else 1.0
		_timer.start()
