extends Area3D
class_name noxx_gas_e
signal gas_damage
@onready var gas_damage_timer: Timer = $gas_damage_timer
var player_in_gas = false

func _on_body_entered(body):
	print("Something entered:", body.name)
	
	if body.is_in_group("player"):
		print("Player entered gas")
		player_in_gas = true
		gas_damage_timer.start()


func _on_body_exited(body: Node3D) -> void:
	gas_damage_timer.stop()
	player_in_gas = false
	print("player exited gas")


func _on_gas_damage_timer_timeout() -> void:
	emit_signal("gas_damage")
