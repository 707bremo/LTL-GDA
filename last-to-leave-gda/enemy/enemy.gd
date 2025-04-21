extends CharacterBody3D


# get all region / area related nodes
@onready var get_nav_map = get_parent().get_node("NavigationRegion3D")
@onready var nav_agent = get_node("NavigationAgent3D")
@onready var FOV_caster = get_node("FOV_cast")


@export var speed : float = 100.0

var all_points = []
var next_point = 0

var in_pursuit : bool = false
var is_at_post : bool = false
var seen_player : bool = false


# fail-safe
@export var negative_pos = 1 

@export var is_patrolling_guard : bool = false


func _ready() -> void:
	
	add_to_group("enemy")
	
	# make some markers for the enemy to relocate themselves to
	for x in get_parent().get_node("patrol_points").get_children():
		
		## the Y must be 1, or else it'll walk very slow
		all_points.append(x.global_position + Vector3(0,1,0))


func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("down"):
		in_pursuit = false
	
	if is_patrolling_guard or in_pursuit:
		check_alert_state(delta)
	
	if not is_patrolling_guard and not in_pursuit:
		back_to_post(delta)
	move_and_slide()
	

func check_alert_state(delta):
	
	if not in_pursuit:
		patrolling(delta)
	
	if in_pursuit:
		pursuit_state(delta)
	

func patrolling(delta):
	
	await get_tree().process_frame
	var direction
	
	nav_agent.target_position = all_points[next_point]
	direction = nav_agent.get_next_path_position() - global_position
	
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed * delta, 1.0)
	direction.y = 0
	
	look_at(global_transform.origin + direction)
	

func pursuit_state(delta):
	
	# Find current enemy location, and change to the new one
	# Current and next locations are the Translations
	var enemy_current_map_pos = global_position
	var current_target = nav_agent.get_next_path_position()
	var change_diretion = (current_target - enemy_current_map_pos).normalized()
	
	velocity = change_diretion * speed * delta
	
	look_at(Vector3(PlayerManager.player_current_pos.x, self.global_transform.origin.y, PlayerManager.player_current_pos.z), Vector3(0,1,0))
	
	


func back_to_post(delta):
	
	
	if not is_at_post:
		
		await get_tree().process_frame
		# direction will continue to change according to the state of the enemy
		var direction
		
		nav_agent.target_position = all_points[0]
		direction = nav_agent.get_next_path_position() - global_position
		direction = direction.normalized()
		
		velocity = velocity.lerp(direction * speed * delta, 1.0)
		
		# for some reason, a bug occurs when this isn't 0, so we'll leave this for now
		direction.y = 0
		
		look_at(global_transform.origin + direction)
		
	if is_at_post:
		
		direction_transition()
		
		

func direction_transition():
	
	# if a posted guard abandons a search or pursuit, it will reset its rotation to its original spot
	var default_rotation = get_parent().get_node("reset_guard_rotations/pg1_reset_marker").global_position
	# must use Basis rotation or else enemy will face opposite direction all the time
	var reset_rotation = Basis.looking_at(default_rotation * negative_pos)
	
	# get and store the current enemy rotation
	var current_rotation = basis.get_rotation_quaternion()
	basis = current_rotation.slerp(reset_rotation, 0.1)
	
	velocity = Vector3.ZERO
	
	


func _on_navigation_agent_3d_target_reached() -> void:
	
	# locate and move enemy to next spots using definitive algorithm
	
	if is_patrolling_guard:
		
		next_point += 1
		
		if next_point >= all_points.size():
			
			# counts very last spot
			next_point = all_points[-1]
			# then resets the spot to 0, indicating a complete cycle
			next_point = 0
			
	
	if not is_patrolling_guard and not in_pursuit:
		
		is_at_post = true
	

func get_new_target(new_target):
	
	nav_agent.set_target_position(new_target)


func _on_timer_timeout() -> void:
	
	
	# every half-second, the timer updates the pathfinder, ruled-in for optimization
	check_sight()
	get_new_target(PlayerManager.player_current_pos)
	

func check_sight():
	
	# player must be colliding with FOV_cast to begin pursuit
	if seen_player:
		
		FOV_caster.look_at(PlayerManager.player_current_pos, Vector3(0,1,0))
		
	
	if FOV_caster.is_colliding():
		
		var collider = FOV_caster.get_collider()
		
		# reverse normal states if player is detected
		if collider.is_in_group("player"):
			in_pursuit = true
			is_at_post = false



func _on_enemy_fov_body_entered(body) -> void:
	
	if body.is_in_group("player"):
		seen_player = true
	

func _on_enemy_fov_body_exited(body) -> void:
	
	if body.is_in_group("player"):
		seen_player = false
