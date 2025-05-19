class_name Player
extends CharacterBody2D

## Emitted when the character finished walking to a target position, in the walk_to method.
signal arrived_to_target_position

@export var max_health := 5
@export var speed := 460.0
@export var drag_factor := 10.0

@export var initial_weapon: ItemWeapon = null
@export var game_over_scene: PackedScene = null

var health := max_health: set = set_health
var gems := 0: set = set_gems

@onready var _damage_audio: AudioStreamPlayer2D = %DamageAudio
@onready var _die_audio: AudioStreamPlayer2D = %DieAudio
@onready var _weapon_holder := %WeaponHolder
@onready var _health_bar: ProgressBar = %HealthBar
@onready var _collision_shape_2d: CollisionShape2D = %CollisionShape2D

@onready var _dust: GPUParticles2D = %Dust
@onready var _animation_player: AnimationPlayer = %AnimationPlayer

@onready var _weapon_texture_rect: TextureRect = %WeaponTextureRect
@onready var _weapon_label: Label = %WeaponLabel
@onready var _gem_label: Label = %GemLabel


func _ready() -> void:
	_health_bar.max_value = max_health
	_health_bar.value = health

	if initial_weapon != null:
		equip_weapon(initial_weapon)

	assert(
		game_over_scene != null,
		"The player's game_over_scene variable is null. " +
		"You need to set the game over scene in the Inspector for the player to work."
	)


func _physics_process(delta: float) -> void:
	var move_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var desired_velocity := speed * move_direction
	var sprint_factor := 1.3 if Input.is_action_pressed("sprint") else 1.0
	desired_velocity *= sprint_factor
	var steering := desired_velocity - velocity
	velocity += steering * drag_factor * delta
	move_and_slide()

	_dust.emitting = velocity.length() > 100.0
	_dust.process_material.direction.x = -move_direction.x
	_dust.process_material.direction.y = -move_direction.y


func equip_weapon(item: ItemWeapon) -> void:
	_weapon_holder.set_weapon(item.weapon.instantiate())
	_weapon_holder.set_hand_texture(item.hand_texture)
	_weapon_label.text = item.display_name
	_weapon_texture_rect.texture = item.texture


func set_health(new_health: int) -> void:
	var previous_health := health
	health = clampi(new_health, 0, max_health)
	_health_bar.value = health

	if health == 0:
		_animation_player.play("die")
		# The lines of code below could instead be part of the die animation.
		_die_audio.play()
		set_physics_process(false)
		_collision_shape_2d.set_deferred("disabled", true)
		_die_audio.finished.connect(
			get_tree().change_scene_to_packed.bind(game_over_scene)
		)
	elif previous_health > health:
		_animation_player.play("damage")
		_damage_audio.play()
	elif previous_health < health:
		_animation_player.play("heal")


func set_gems(new_gems: int) -> void:
	gems = clampi(new_gems, 0, 99)
	_gem_label.text = str(gems).pad_zeros(2)


func walk_to(destination_global_position: Vector2) -> void:
	set_physics_process(false)

	var direction := global_position.direction_to(destination_global_position)
	_dust.emitting = true

	var distance := global_position.distance_to(destination_global_position)
	var duration :=  distance / speed * 4.0

	var tween := create_tween()
	tween.tween_property(self, "global_position", destination_global_position, duration)
	tween.finished.connect(func():
		_dust.emitting = false
		arrived_to_target_position.emit()
	)
