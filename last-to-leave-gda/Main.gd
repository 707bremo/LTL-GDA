extends Node

const Pickup = preload("res://UI/Inventory/item/pickup.tscn")

@onready var test_player: CharacterBody3D = $test_player
@onready var inv_interface: Control = $UI/InvInterface


func _ready() -> void:
	test_player.toogle_inventory.connect(toogle_inv_interface)
	inv_interface.set_player_inventory_data(test_player.inventory_data)
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toogle_inventory.connect(toogle_inv_interface)

func toogle_inv_interface(external_inventory_owner = null) -> void:
	inv_interface.visible = not inv_interface.visible
	
	if inv_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if external_inventory_owner and inv_interface.visible:
		inv_interface.set_external_inventory(external_inventory_owner)
	else:
		inv_interface.clear_external_inventory()


func _on_inv_interface_drop_slot_data(slot_data: SlotData) -> void:
	var pick_up = Pickup.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = test_player.get_drop_position()
	add_child(pick_up)
