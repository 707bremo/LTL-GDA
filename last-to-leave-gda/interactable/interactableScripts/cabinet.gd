extends StaticBody3D
class_name Containers

signal toogle_inventory(external_inventory_owner)

@export var inventory_data: InventoryData
@export var outline: MeshInstance3D

func player_interact() -> void:
	toogle_inventory.emit(self)



func gain_highlight() -> void:
	outline.visible = true


func lose_highlight() -> void:
	outline.visible = false
