extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

var SPEED = 2.0

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	velocity = new_velocity
	move_and_slide()

func update_target_location(target_location):
	nav_agent.target_position = target_location

func _on_navigation_agent_3d_target_reached():
	SPEED = 0

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()
