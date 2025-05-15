extends CharacterBody3D

signal attack_player 

@export var WalkSpeed: float = 1.5

@onready var nav_agent = $NavigationAgent3D
@onready var attack_timer = $AttackTimer  # Ensure this Timer node is added in your scene

var SPEED = 2.0
var player_pos = PlayerManager.player_current_pos

func _ready():
	var enemy_wander = get_node("/followingEnemy/StateMachine/EnemyWander")

func _physics_process(delta):
	player_pos = PlayerManager.player_current_pos
	if player_pos == null:
		return

	var distance_to_player = global_transform.origin.distance_to(player_pos)

	if distance_to_player > 5.0:
		look_at(player_pos, Vector3.UP)
		update_target_location(player_pos)
		SPEED = 2.0
		if not attack_timer.is_stopped():
			attack_timer.stop()
	else:
		SPEED = 0
		look_at(player_pos, Vector3.UP)
		if attack_timer.is_stopped():
			attack_timer.start()

	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	velocity = new_velocity
	move_and_slide()

func update_target_location(target_location):
	nav_agent.target_position = target_location

func _on_navigation_agent_3d_target_reached():
	pass

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()

func _on_attack_timer_timeout():
	emit_signal("attack_player")
