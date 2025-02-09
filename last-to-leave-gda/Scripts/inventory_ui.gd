extends Control

@onready var inventory_container: GridContainer = $InventoryContainer





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()

func _on_inventory_updated():
	clear_grid_container()
# Add the slots to the inventory
	for item in Global.inventory:
		var slot = Global.inventory_slot_scene.instantiate()
		inventory_container.add_child(slot)
		if item != null:
			slot.set_item(item)
		else:
			slot.set_empty()

func clear_grid_container():
	while inventory_container.get_child_count() > 0:
		var child = inventory_container.get_child(0)
		inventory_container.remove_child(child)
		child.queue_free()
