extends Node

# Inventory items are stored in this array boi
var inventory = []


signal inventory_updated


var player_node: Node = null

func _ready():
	inventory.resize(30)


func add_inventory_item():
	inventory_updated.emit()
	
func remove_inventory_item():
	inventory_updated.emit()
	
func increase_inventory_size():
	inventory_updated.emit()
	

func set_player_reference(player):
	player_node = player
