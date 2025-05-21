extends CharacterBody3D

@export var inventory_data: InventoryData
@export var equip_inventory_data: EquipInvData
@export var weapon_inventory_data: WeaponInvData

signal toogle_inventory()

var speed
const FATIGUED = 3.22
const WALK_SPEED = 5.0
const SPRINT_SPEED = 50.0
const JUMP_VELOCITY = 4.8
const SENSITIVITY = 0.004

const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0

const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

var gravity = 9.8

var armor: int = 30
var max_health: float = 100.0
var health: int = 100
var health_regen_ae: float = 0.5
var current_health = health
var health_regen_IN: int = 1

var max_stamina: float = 100
var stamina: float = 100
var stamina_lost: float = 20
var can_regen = true
var time_to_wait: float = 2
var can_fatigued_timer = true
var fatigued_wait: float = 5
var fatigued_timer = 0
var stamina_timer = 0
var can_start_timer = true
var is_sprinting = false

var max_hunger: float = 100.0
var current_hunger = max_hunger
var hunger_lost: float = 0.25

var stable_color = Color("00ff00")
var worn_color = Color("GREEN_YELLOW")
var damaged_color = Color("ORANGE")
var critical_color = Color("RED")

var is_dead = false
var in_gas = false
var gas_damage_timer = 0.0
const GAS_DAMAGE_INTERVAL = 2.0

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var interact_ray: RayCast3D = $Head/Camera3D/InteractRay
@onready var p_health_bar: ProgressBar = $HUD/PlayerHealthBar
@onready var armor_bar: TextureProgressBar = $HUD/PlayerHealthBar/ArmorBar
@onready var stamina_bar: TextureProgressBar = $HUD/PlayerHealthBar/StaminaBar
@onready var stamina_bar_anim: AnimationPlayer = $StaminaBarAnim
@onready var fatigued_blinker: ColorRect = $FatiguedBlinker
@onready var hunger_bar: ProgressBar = $HUD/PlayerHealthBar/HungerBar
@onready var damage_overlay: TextureRect = $DamageOverlay
@onready var damage_flash_anim: AnimationPlayer = $DamageFlashAnim
@onready var crystalize_sound: AudioStreamPlayer3D = $CrystalizeSound
@onready var shiver_sound: AudioStreamPlayer3D = $ShiverSound
@onready var death_anim: AnimationPlayer = $DeathAnim
@onready var death_layer: CanvasLayer = $DeathLayer
@onready var player_scream: AudioStreamPlayer3D = $PlayerScream
@onready var death_overlay: ColorRect = $DeathLayer/DeathOverlay
@onready var death_menu_anim: AnimationPlayer = $DeathMenuAnim
@onready var death_menu_layer: CanvasLayer = $DeathMenuLayer
@onready var death_menu_rect: ColorRect = $DeathMenuLayer/DeathMenuRect
@onready var retry_button: Button = $DeathMenuLayer/VBoxContainer/RetryButton
@onready var exit_to_menu_button: Button = $DeathMenuLayer/VBoxContainer/ExitToMenuButton

func _ready():
	if hunger_bar:
		hunger_bar.max_value = max_hunger
		hunger_bar.value = current_hunger

	if p_health_bar:
		p_health_bar.value = current_health

	stamina_bar.visible = false
	stamina_bar.value = stamina
	armor_bar.value = armor
	armor_bar.tint_progress = damaged_color
	PlayerManager.player = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	var gas_area = get_node_or_null("/root/Main/GasArea")
	if gas_area:
		gas_area.connect("gas_damage", Callable(self, "_on_noxx_gas_damage"))
		gas_area.connect("left_gas", Callable(self, "_on_noxx_left_gas"))

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-100), deg_to_rad(60))

	if Input.is_action_just_pressed("open_inv"):
		toogle_inventory.emit()

	if Input.is_action_just_pressed("interact"):
		interact()

func _physics_process(delta):
	if is_dead:
		return

	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("sprint"):
		is_sprinting = true
		can_regen = false
		speed = SPRINT_SPEED
		stamina -= stamina_lost * delta
	else:
		is_sprinting = false
		speed = WALK_SPEED

	stamina_bar.value = stamina

func _process(delta):
	if is_dead:
		return

	current_hunger -= hunger_lost * delta
	current_hunger = clamp(current_hunger, 0, max_hunger)

	if hunger_bar:
		hunger_bar.value = current_hunger

	if current_hunger == 0:
		current_health -= 0.099 * delta

	if p_health_bar:
		p_health_bar.value = current_health

	if current_hunger >= 90:
		current_health += health_regen_IN * delta
	elif current_hunger >= 50:
		current_health += health_regen_ae * delta

	current_health = clamp(current_health, 0, max_health)

	if in_gas:
		gas_damage_timer += delta
		if gas_damage_timer >= GAS_DAMAGE_INTERVAL:
			current_health -= 10.1
			gas_damage_timer = 0.0
			damage_flash_anim.play("damage flash")
			if not crystalize_sound.playing:
				crystalize_sound.play()
			if not shiver_sound.playing:
				shiver_sound.play()

	change_UI_APP()
	check_stamina_regen(delta)
	check_player_camera(delta)
	move_and_slide()

	if current_health <= 0:
		die()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

func interact():
	if interact_ray.is_colliding():
		interact_ray.get_collider().player_interact()

func get_drop_position() -> Vector3:
	var direction = -camera.global_transform.basis.z
	return camera.global_position + direction

func replenish_hunger(gain_hunger_value: int):
	current_hunger += gain_hunger_value
	hunger_bar.value = current_hunger

func gain_health(heal_value: int):
	if current_hunger >= 90:
		current_health += heal_value
		p_health_bar.value = current_health

func gain_armor(armor_value: int):
	armor += armor_value
	armor_bar.value = armor
	change_UI_APP()

func change_UI_APP():
	if armor_bar.value >= 75:
		armor_bar.tint_progress = stable_color
	elif armor_bar.value >= 50:
		armor_bar.tint_progress = worn_color
	elif armor_bar.value >= 25:
		armor_bar.tint_progress = damaged_color
	else:
		armor_bar.tint_progress = critical_color

	var health_stylebox = p_health_bar.get_theme_stylebox("fill")
	var hunger_stylebox = hunger_bar.get_theme_stylebox("fill")

	if health_stylebox is StyleBoxFlat:
		if current_health >= 75:
			health_stylebox.bg_color = stable_color
		elif current_health >= 50:
			health_stylebox.bg_color = worn_color
		elif current_health >= 25:
			health_stylebox.bg_color = damaged_color
		else:
			health_stylebox.bg_color = critical_color
		p_health_bar.add_theme_stylebox_override("fill", health_stylebox)

	if hunger_stylebox is StyleBoxFlat:
		if current_hunger >= 75:
			hunger_stylebox.bg_color = stable_color
		elif current_hunger >= 50:
			hunger_stylebox.bg_color = worn_color
		elif current_hunger >= 25:
			hunger_stylebox.bg_color = damaged_color
		else:
			hunger_stylebox.bg_color = critical_color
		hunger_bar.add_theme_stylebox_override("fill", hunger_stylebox)

func check_player_camera(delta):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)

	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

func check_stamina_regen(delta):
	if not can_regen and stamina_bar.value < 100:
		stamina_bar.visible = true
		can_start_timer = true
		if can_start_timer:
			stamina_timer += delta
			if stamina_timer >= time_to_wait:
				can_regen = true
				can_start_timer = false
				stamina_timer = 0

	if stamina_bar.value > 60:
		fatigued_blinker.visible = false
		stamina_bar_anim.stop()

	if stamina_bar.value == 0:
		speed = FATIGUED
		fatigued_blinker.visible = true
		stamina_bar_anim.play("blink")
		can_fatigued_timer = true
		if can_fatigued_timer:
			fatigued_timer += delta
			if fatigued_timer >= fatigued_wait:
				can_regen = true
				can_fatigued_timer = false
				fatigued_timer = 0
				speed = WALK_SPEED

	if speed == FATIGUED and is_sprinting:
		is_sprinting = false

	if stamina_bar.value == 100:
		can_regen = false
		stamina_bar.visible = false
	if can_regen:
		stamina += stamina_lost * delta
		can_start_timer = false
		stamina_timer = 0

func _on_noxx_gas_damage() -> void:
	if is_dead:
		return
	in_gas = true
	gas_damage_timer = GAS_DAMAGE_INTERVAL  # triggers instant damage

func _on_noxx_left_gas() -> void:
	if is_dead:
		return
	in_gas = false
	gas_damage_timer = 0.0
	damage_flash_anim.play_backwards("damage flash")
	if crystalize_sound.playing:
		crystalize_sound.stop()
	if shiver_sound.playing:
		shiver_sound.stop()

func die():
	if is_dead:
		return
	is_dead = true
	for child in get_tree().get_nodes_in_group("audio"):
		if child is AudioStreamPlayer or child is AudioStreamPlayer3D:
			child.stop()

	crystalize_sound.stop()
	shiver_sound.stop()

	player_scream.play()
	death_layer.visible = true
	death_overlay.visible = true
	death_anim.play("death_yell")
	set_process(false)
	set_physics_process(false)

func _on_death_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death_yell":
		crystalize_sound.stop()
		shiver_sound.stop()
		death_anim.play("you died")

func _on_retry_button_pressed() -> void:
	pass # change to scene "res://world/test_room.tscn"

func _on_exit_to_menu_button_pressed() -> void:
	pass # change to scene "res://UI/main_menu.tscn"

func _on_death_menu_anim_animation_finished(anim_name: StringName) -> void:
	pass # Replace with function body.
