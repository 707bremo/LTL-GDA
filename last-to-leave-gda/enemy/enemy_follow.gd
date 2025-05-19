extends State
class_name EnemyFollow


@onready var enemy = get_parent().get_parent()
var player: CharacterBody3D = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func process(delta: float):
	enemy.nav_agent.set_target_position(player.global_position)
	
	if enemy.global_position.distance_to(player.global_position) > enemy.PursuitDistance:
		emit_signal("Transitioned", self, "EnemyWander")
		enemy.look_at(Vector3(player.global_position.x, enemy.global_position.y, player.global_position.z))
	

func physics_process(delta: float) -> void:
	if enemy.nav_agent.is_navigation_finished():
		return
	
	var next_position: Vector3 = enemy.nav_agent.get_next_path_position()
	enemy.velocity = enemy.global_position.direction_to(next_position) * enemy.RunSpeed
