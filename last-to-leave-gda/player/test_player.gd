extends CharacterBody3D

@export var inventory_data: InventoryData

signal toogle_inventory()




var speed
const FATIGUED = 3.22
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.8
const SENSITIVITY = 0.004

#bob variables
const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0

#fov variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8


# vitals
var health: int = 3
var armor: int = 30
var max_stamina: float = 100
var stamina: float = 100
var stamina_lost: float = 20


# vital (Conditions)
var can_regen = true
var time_to_wait: float = 2
var can_fatigued_timer = true
var fatigued_wait: float = 5
var fatigued_timer = 0
var stamina_timer = 0
var can_start_timer = true
var is_sprinting = false


@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var interact_ray: RayCast3D = $Head/Camera3D/InteractRay
@onready var p_health_bar: ProgressBar = $HUD/PlayerHealthBar
@onready var armor_bar: TextureProgressBar = $HUD/PlayerHealthBar/ArmorBar
@onready var stamina_bar: TextureProgressBar = $HUD/PlayerHealthBar/StaminaBar
@onready var stamina_bar_anim: AnimationPlayer = $StaminaBarAnim
@onready var fatigued_blinker: ColorRect = $FatiguedBlinker


func _ready():
	stamina_bar.visible = false
	stamina_bar.value = stamina
	armor_bar.value = armor
	p_health_bar.value = health
	PlayerManager.player = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


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
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
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
		#if stamina < max_stamina and not FATIGUED:
			#stamina += stamina_lost * delta
		#if stamina > 25:
			#fatigued_blinker.visible = false
			#$StaminaBarAnim.stop()
		#if stamina < 1:
			#speed = FATIGUED
			#fatigued_blinker.visible = true
			#$StaminaBarAnim.play("blink")
	stamina_bar.value = stamina

func _process(delta) -> void:
	if can_regen == false and stamina_bar.value < 100:
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
			$StaminaBarAnim.stop()
	
	if stamina_bar.value == 0:
		speed = FATIGUED
		fatigued_blinker.visible = true
		$StaminaBarAnim.play("blink")
		can_fatigued_timer = true
		if can_fatigued_timer:
			fatigued_timer += delta
			if fatigued_timer >= fatigued_wait:
				can_regen = true
				can_fatigued_timer = false
				fatigued_timer = 0
				speed = WALK_SPEED
	
	
	if speed == FATIGUED and is_sprinting == true:
		is_sprinting = false
	
	if stamina_bar.value == 100:
		can_regen = false
		stamina_bar.visible = false
	if can_regen == true:
		stamina += stamina_lost * delta
		can_start_timer = false
		stamina_timer = 0



	# Get the input direction and handle the movement/deceleration.
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
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos


func interact() -> void:
	if interact_ray.is_colliding():
		interact_ray.get_collider().player_interact()


func get_drop_position() -> Vector3:
	var direction = -camera.global_transform.basis.z
	return camera.global_position + direction


func heal(heal_value: int) -> void:
	health += heal_value
	p_health_bar.value = health

func gain_armor(armor_value: int) -> void:
	armor += armor_value
	armor_bar.value = armor
