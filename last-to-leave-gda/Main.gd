extends Node

@onready var test_player: CharacterBody3D = $test_player
@onready var inv_interface: Control = $UI/InvInterface


func _ready() -> void:
	test_player.toogle_inventory.connect(toogle_inv_interface)
	inv_interface.set_player_inventory_data(test_player.inventory_data)

func toogle_inv_interface() -> void:
	inv_interface.visible = not inv_interface.visible
	
	if inv_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
