extends CharacterBody3D

signal attack_player 

@export var WalkSpeed: float = 1.5
@export var RunSpeed: float = 1.8
@export var PursuitDistance: float = 5.0


@onready var nav_agent = $NavigationAgent3D
@onready var attack_timer = $AttackTimer  # Ensure this Timer node is added in your scene

var player: CharacterBody3D = null
var SPEED = 2.0
var player_pos = PlayerManager.player_current_pos

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta):
	move_and_slide()

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
