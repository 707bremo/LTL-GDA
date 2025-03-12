extends CharacterBody3D
 
@export var inventory_data: InventoryData

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
 
var _mouse_input : bool = false
var _rotation_input : float
var _tilt_input : float
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
 
func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().q

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
 
 
func _unhandled_input(event: InputEvent) -> void:
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode()
Input.MOUSE_MODE_CAPTURED

 
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
 
 
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
 
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
 
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
 
	move_and_slide()
