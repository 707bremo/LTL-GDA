class_name ItemHealing_01 extends Item_01

@export var healing_amount := 1


func use(player: Player_01) -> void:
	player.health += healing_amount
