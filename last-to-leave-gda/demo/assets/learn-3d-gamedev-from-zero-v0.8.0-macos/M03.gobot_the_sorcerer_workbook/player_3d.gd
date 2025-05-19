extends CharacterBody3D

@export_range(0.3, 12.0, 0.1) var max_speed := 6.0
@export_range(1.0, 50.0, 0.1) var steering_factor := 20.0

func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction:= Vector3(input_vector.x,0.0, input_vector.y)
	var desired_ground_velocity := max_speed * direction
	var steering_vector := desired_ground_velocity - velocity
	steering_vector.y = 0.0
	var steering_amount: float =min(steering_factor * delta, 1.0)
	velocity += steering_vector * steering_amount
	const GRAVITY := 40.0 * Vector3.DOWN
	velocity += GRAVITY * delta
	move_and_slide()
