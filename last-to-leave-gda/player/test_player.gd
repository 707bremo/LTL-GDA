extends CharacterBody3D

@export var inventory_data: InventoryData
@export var equip_inventory_data: EquipInvData
@export var weapon_inventory_data: WeaponInvData

signal toogle_inventory()
signal step
signal opening_container

# variable for footstep
var can_play : bool = true


# speed variables
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


# *** vitals (Main-Values) ***
var armor: int = 30

# *** vitals (Conditions) ***

# health
var max_health: float = 100.0
var health: int = 40
var health_regen_ae: float = 0.5
var current_health = health
var health_regen_IN: int = 1

# stamina
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





# hunger
var max_hunger: float = 100.0
var current_hunger = max_hunger
var hunger_lost: float = 0.25



# armor
var stable_color = Color("00ff00")
var worn_color = Color("GREEN_YELLOW") 
var damaged_color = Color("ORANGE")
var critical_color = Color("RED")


# player UI and camera
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var interact_ray: RayCast3D = $Head/Camera3D/InteractRay
@onready var p_health_bar: ProgressBar = $HUD/PlayerHealthBar
@onready var armor_bar: TextureProgressBar = $HUD/PlayerHealthBar/ArmorBar
@onready var stamina_bar: TextureProgressBar = $HUD/PlayerHealthBar/StaminaBar
@onready var stamina_bar_anim: AnimationPlayer = $StaminaBarAnim
@onready var fatigued_blinker: ColorRect = $FatiguedBlinker
@onready var hunger_bar: ProgressBar = $HUD/PlayerHealthBar/HungerBar


# reference to floor raycast
@onready var floor_type_cast: RayCast3D = $floor_type_cast


func _ready():
	
	self.opening_container.connect(play_container_sound)
	
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
	
	
	# Constantly decrease the hunger over time.
	current_hunger -= hunger_lost * delta
	current_hunger = clamp(current_hunger, 0, max_hunger) # Cannot go past 0.
	
	
	if hunger_bar:
		hunger_bar.value = current_hunger
	
	if current_hunger == 0:
		current_health -= 0.099 * delta # Once hunger reaches 0, player will start to lose health very slowly.
		hunger_bar.value = current_hunger
	
	if p_health_bar:
		p_health_bar.value = current_health
		print(current_health)
	
	# Checks if the hunger exceeds boost limit. If the hunger is below 90, drop the health boost.
	if current_hunger >= 90:
		current_health += health_regen_IN * delta 
	if current_hunger < 90 and current_hunger >= 50:
		current_health += health_regen_ae * delta
	if current_health == 100:
		p_health_bar.value = current_health
	
	
	current_health = clamp(current_health, 0, max_health)
	
	
	# *** Change the color of the health bar based on the player's physical conditions ***
	# when health and hunger are at least 75 or more
	change_UI_APP()
	
	# Check if the player is able to regen stamina. If true, stamina will increase over time.
	check_stamina_regen(delta)
	
	# Get the input direction and handle the movement/deceleration.
	check_player_camera(delta)
	move_and_slide()


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	
	var low_pos = BOB_AMP - 0.05
	
	if pos.y > -low_pos:
		can_play = true
		
	if pos.y < -low_pos and can_play:
		can_play = false
		emit_signal("step")
	
	return pos


func interact() -> void:
	if interact_ray.is_colliding():
		interact_ray.get_collider().player_interact()


func get_drop_position() -> Vector3:
	var direction = -camera.global_transform.basis.z
	return camera.global_position + direction


func replenish_hunger(gain_hunger_value: int) -> void:
	current_hunger += gain_hunger_value
	hunger_bar.value = current_hunger

func gain_health(heal_value: int) -> void:
	if current_hunger >= 90:
		current_health += heal_value
		p_health_bar.value = health

func gain_armor(armor_value: int) -> void:
	armor += armor_value
	armor_bar.value = armor
	change_UI_APP()

# FOR APPEARANCE ONLY
func change_UI_APP():
	if armor_bar.value <= 100 and armor_bar.value >= 75:
		armor_bar.tint_progress = stable_color
	if armor_bar.value <= 75 and armor_bar.value >= 50:
		armor_bar.tint_progress = worn_color
	if armor_bar.value <= 50 and armor_bar.value >= 25:
		armor_bar.tint_progress = damaged_color
	if armor_bar.value <= 25 and armor_bar.value > 0:
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
		
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

func check_stamina_regen(delta):
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
	
	# The regeneration of stamina shouldn't exceed 100.
	if stamina_bar.value == 100: 
		can_regen = false
		stamina_bar.visible = false
	if can_regen == true:
		stamina += stamina_lost * delta
		can_start_timer = false
		stamina_timer = 0
	

func play_container_sound():
	$cabinet_sound.play()
