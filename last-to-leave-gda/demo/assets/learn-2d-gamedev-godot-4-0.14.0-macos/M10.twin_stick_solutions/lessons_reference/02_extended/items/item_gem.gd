# Compiles all the data for a given item in the game, which can be used by
# collectibles and the UI alike.
class_name ItemGem extends Item

@export var value := 1

# Override this function to define what happens when the player uses the item.
func use(player: Player) -> void:
	player.gems += value
