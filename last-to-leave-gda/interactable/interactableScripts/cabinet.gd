extends StaticBody3D
class_name Containers

signal toogle_inventory(external_inventory_owner)

@onready var test_player: CharacterBody3D = get_tree().get_node("test_player")
@export var inventory_data: InventoryData
@export var outline: MeshInstance3D

func player_interact() -> void:
	toogle_inventory.emit(self)

func container_sounds() -> void:
	test_player.emit_signal("opening_container")

func gain_highlight() -> void:
	outline.visible = true


func lose_highlight() -> void:
	outline.visible = false
