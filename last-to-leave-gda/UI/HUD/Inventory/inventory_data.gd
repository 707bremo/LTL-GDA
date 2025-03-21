extends Resource
class_name InventoryData


signal inventory_updated(inventory_data: InventoryData)
signal inventory_interact(inventory_data: InventoryData, index: int, button: int)
signal weight_updated(current_weight: float, max_weight: float)

@export var slot_datas: Array[SlotData]
var current_weight: float = 0.0
const MAX_WEIGHT: float = 3.0


# inventory_data.gd (ADD THIS AFTER @export var slot_datas)
func _init() -> void:
	calculate_current_weight()


func calculate_current_weight() -> void:
	current_weight = 0.0
	for slot_data in slot_datas:
		if slot_data:
			current_weight += slot_data.item_data.weight * slot_data.quantity
	weight_updated.emit(current_weight, MAX_WEIGHT)

func grab_slot_data(index: int) -> SlotData:
	var slot_data = slot_datas[index]
	
	if slot_data:
		slot_datas[index] = null
		calculate_current_weight()
		inventory_updated.emit(self)
		return slot_data
	else:
		return null

func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var potential_weight = current_weight - (slot_datas[index].item_data.weight * slot_datas[index].quantity if slot_datas[index] else 0)
	potential_weight += grabbed_slot_data.item_data.weight * grabbed_slot_data.quantity

	if potential_weight > MAX_WEIGHT:
		return grabbed_slot_data  # Reject the drop
	
	
	var slot_data = slot_datas[index]
	
	var return_slot_data: SlotData
	if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data)
	else:
		slot_datas[index] = grabbed_slot_data
		return_slot_data = slot_data
	calculate_current_weight()
		
	inventory_updated.emit(self)
	return return_slot_data

func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var potential_weight = current_weight + grabbed_slot_data.item_data.weight
	if potential_weight > MAX_WEIGHT:
		return grabbed_slot_data  # Reject the drop
	
	
	
	var slot_data = slot_datas[index]
	
	if not slot_data:
		slot_datas[index] = grabbed_slot_data.create_single_slot_data()
	elif slot_data.can_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())
	calculate_current_weight()
	
	inventory_updated.emit(self)
	
	if grabbed_slot_data.quantity > 0:
		return grabbed_slot_data
	else:
		return null


func use_slot_data(index: int) -> void:
	var slot_data = slot_datas[index]
	if not slot_data:
		return
	
	if slot_data.item_data is ItemDataConsumable:
		slot_data.quantity -= 1
		if slot_data.quantity < 1:
			slot_datas[index] = null
		calculate_current_weight()
	PlayerManager.use_slot_data(slot_data)
	
	print(slot_data.item_data.name)
	
	
	inventory_updated.emit(self)

func pick_up_slot_data(slot_data: SlotData) -> bool:
	var added_weight = slot_data.item_data.weight * slot_data.quantity
	if current_weight + added_weight > MAX_WEIGHT:
		return false
	for index in slot_datas.size():
		if slot_datas[index] and slot_datas[index].can_fully_merge_with(slot_data):
			slot_datas[index].fully_merge_with(slot_data)
			calculate_current_weight()
			inventory_updated.emit(self)
			return true
	
	for index in slot_datas.size():
		if not slot_datas[index]:
			slot_datas[index] = slot_data
			calculate_current_weight()
			inventory_updated.emit(self)
			return true
	
	return false



func on_slot_clicked(index: int, button: int) -> void:
	inventory_interact.emit(self, index, button)
