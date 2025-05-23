extends Control

signal drop_slot_data(slot_data: SlotData)
signal force_quit_source


var grabbed_slot_data: SlotData
var external_inventory_owner


@onready var player_inv: PanelContainer = $PlayerInv
@onready var grabbed_slot: PanelContainer = $GrabbedSlot
@onready var external_inv: PanelContainer = $ExternalInv
@onready var weight_bar: ProgressBar = $WeightBar
@onready var equip_inv: PanelContainer = $EquipInv
@onready var weapon_inv: PanelContainer = $WeaponInv

func _physics_process(delta: float) -> void:
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5,5)
	
	if external_inventory_owner \
			and external_inventory_owner.global_position.distance_to(PlayerManager.get_global_position()) > 3:
		force_quit_source.emit()

func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	inventory_data.weight_updated.connect(update_weight_bar)
	player_inv.set_inventory_data(inventory_data)


func set_equip_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	inventory_data.weight_updated.connect(update_weight_bar)
	equip_inv.set_inventory_data(inventory_data)


func set_weapon_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	inventory_data.weight_updated.connect(update_weight_bar)
	weapon_inv.set_inventory_data(inventory_data)

func update_weight_bar(current_weight: float, max_weight: float) -> void:
	weight_bar.max_value = max_weight
	weight_bar.value = current_weight

func set_external_inventory(_external_inventory_owner) -> void:
	external_inventory_owner = _external_inventory_owner
	var inventory_data = external_inventory_owner.inventory_data
	
	inventory_data.inventory_interact.connect(on_inventory_interact)
	external_inv.set_inventory_data(inventory_data)
	
	
	external_inv.show()


func clear_external_inventory() -> void:
	if external_inventory_owner:
		var inventory_data = external_inventory_owner.inventory_data
		
		inventory_data.inventory_interact.disconnect(on_inventory_interact)
		external_inv.clear_inventory_data(inventory_data)
		
		
		external_inv.hide()
		external_inventory_owner = null


func on_inventory_interact(inventory_data: InventoryData, 
		index: int, button: int) -> void:
	
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
		[null, MOUSE_BUTTON_RIGHT]:
			inventory_data.use_slot_data(index)
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)
	
	update_grabbed_slot()




func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and event.is_pressed() \
			and grabbed_slot_data:
			
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				drop_slot_data.emit(grabbed_slot_data)
				grabbed_slot_data = null
			MOUSE_BUTTON_RIGHT:
				drop_slot_data.emit(grabbed_slot_data.create_single_slot_data())
				if grabbed_slot_data.quantity < 1:
					grabbed_slot_data = null
		
		update_grabbed_slot()


func _on_visibility_changed() -> void:
	if not visible and grabbed_slot_data:
		drop_slot_data.emit(grabbed_slot_data)
		grabbed_slot_data = null
		update_grabbed_slot()
