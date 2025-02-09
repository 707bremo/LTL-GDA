extends Node

# Inventory items are stored in this array boi
var inventory = []


signal inventory_updated


var player_node: Node = null
@onready var inventory_slot_scene = preload("res://Scenes/inventory_slot.tscn")




func _ready():
	inventory.resize(30)


func add_inventory_item(item):
		for i in range(inventory.size()):
			if inventory[i] != null and inventory[i]["item_type"] == item["item_type"] and inventory[i]["item_description"] == item["item_description"]:
				inventory[i]["quantity"] == item["quantity"]
				inventory_updated.emit()
				return true
			elif inventory[i] == null:
				inventory[i] = item
				inventory_updated.emit()
				return true
			return false
	
func remove_inventory_item():
	inventory_updated.emit()
	
func increase_inventory_size():
	inventory_updated.emit()
	

func set_player_reference(player):
	player_node = player
