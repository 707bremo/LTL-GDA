extends Camera3D

@export var acceleration = 25.0
@export var moveSpeed = 5.0
@export var mouseSpeed = 300.0

var velocity = Vector3.ZERO
var lookAngles = Vector2.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	lookAngles.y = clamp(lookAngles.y, PI / -2, PI / 2)
	set_rotation(Vector3(lookAngles.y, lookAngles.x, 0))
	var direction = updateDirection()
	if direction.length_squared() > 0:
		velocity += direction * acceleration * delta
	if velocity.length() > moveSpeed:
		velocity = velocity.normalized() * moveSpeed
	
	translate(velocity * delta)

func _input(event):
	if event is InputEventMouseMotion:
		lookAngles -= event.relative / mouseSpeed

func updateDirection():
	var dir = Vector3()
	if Input.is_action_pressed("camera_forward"):
		dir += Vector3.FORWARD
	if Input.is_action_pressed("camera_backward"):
		dir += Vector3.BACK
	if Input.is_action_pressed("camera_left"):
		dir += Vector3.LEFT
	if Input.is_action_pressed("camera_right"):
		dir += Vector3.RIGHT
	if Input.is_action_pressed("camera_up"):
		dir += Vector3.UP
	if Input.is_action_pressed("camera_down"):
		dir += Vector3.DOWN
	if dir == Vector3.ZERO:
		velocity = Vector3.ZERO
	
	return dir.normalized()
