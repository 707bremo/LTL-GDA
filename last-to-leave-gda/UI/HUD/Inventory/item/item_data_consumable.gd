extends ItemData
class_name ItemDataConsumable

@export var heal_value: int
@export var armor_value: int
@export var gain_hunger_value: int


func use(target) -> void:
	if gain_hunger_value != 0:
		target.replenish_hunger(gain_hunger_value)
	if heal_value != 0:
		target.gain_health(heal_value)
	if armor_value != 0:
		target.gain_armor(armor_value)
