extends CharacterBody3D
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_sense = 0.1
@onready var head = $head
@onready var camera = $head/Camera3D
@onready var view__model_camera: Camera3D = $"head/Camera3D/SubViewportContainer/SubViewport/view_ model_camera"

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$head/Camera3D/SubViewportContainer/SubViewport.size = DisplayServer.window_get_size()

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
		view__model_camera.sway(Vector2(event.relative.x,event.relative.y))

func _physics_process(delta):
	$"head/Camera3D/SubViewportContainer/SubViewport/view_ model_camera".global_transform = camera.global_transform
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
