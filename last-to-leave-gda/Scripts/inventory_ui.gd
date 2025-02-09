extends Control

@onready var inventory_container: GridContainer = $InventoryContainer





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()

func _on_inventory_updated():
	clear_grid_container()



func clear_grid_container():
	while inventory_container.get_child_count() > 0:
		var child = inventory_container.get_child(0)
		inventory_container.remove_child(child)
		child.queue_free()
