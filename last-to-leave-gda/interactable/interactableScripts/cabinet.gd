extends StaticBody3D

signal toogle_inventory(external_inventory_owner)

@export var inventory_data: InventoryData

func player_interact() -> void:
	toogle_inventory.emit(self)
