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
	
	#look_at(Vector3(Global.player_current_pos.x, self.global_transform.origin.y, Global.player_current_pos.z), Vector3)
