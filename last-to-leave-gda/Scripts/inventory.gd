# Inventory.gd +++
extends Control

@onready var slot_scene = preload("res://Scenes/slot.tscn")
@onready var item_scene = preload("res://Scenes/item.tscn")
@onready var grid_container: GridContainer = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var scroll_container = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer
@onready var col_count = grid_container.columns


var grid_array := []
var item_held = null # Should be null because no item is held before the inventory is opened.
var current_slot = null # Should be null because no slot is selected before the inventory is opened.
var can_place := false
var icon_anchor : Vector2

# When the scene plays, it should add 42 available slots in the grid.
func _ready() -> void:
	for i in range(42):
		create_slot()


# Left clicking = Pick up item / Place item
# Right clicking = Rotate item
func _process(delta: float) -> void:
	if item_held:
		if Input.is_action_just_pressed("mouse_rightclick"):
			rotate_item()
		
		if Input.is_action_just_pressed("mouse_leftclick"):
			if scroll_container.get_global_rect().has_point(get_global_mouse_position()):
				place_item()
		
	else:
		if Input.is_action_just_pressed("mouse_leftclick"):
			if scroll_container.get_global_rect().has_point(get_global_mouse_position()):
				pick_item()



# Create the slot according to how many columns there are on the grid.
# It is, and should only be a child of the GridContainer node.
func create_slot():
	var new_slot = slot_scene.instantiate()
	new_slot.slot_ID = grid_array.size()
	grid_array.push_back(new_slot)
	grid_container.add_child(new_slot)
	new_slot.slot_entered.connect(_on_slot_mouse_entered)
	new_slot.slot_exited.connect(_on_slot_mouse_exited)



# When the mouse enters the slot.
func _on_slot_mouse_entered(a_Slot):
	icon_anchor = Vector2(10000, 10000)
	current_slot = a_Slot
	if item_held:
		check_slot_availability(current_slot)
		set_grids.call_deferred(current_slot)


# When the mouse exits the slot.
func _on_slot_mouse_exited(a_Slot):
	clear_grid()


# This runs a check to see if the slot is available. If it's occupied, the item cannot be placed on said spot.
func check_slot_availability(a_Slot):
	for grid in item_held.item_grids:
		var grid_to_check = a_Slot.slot_ID + grid[0] + grid[1] * col_count
		var line_switch_check = a_Slot.slot_ID % col_count + grid[0]
		if line_switch_check < 0 or line_switch_check >= col_count:
			can_place = false
			return
		if grid_to_check < 0 or grid_to_check >= grid_array.size():
			can_place = false
			return
		if grid_array[grid_to_check].state == grid_array[grid_to_check].States.TAKEN:
			can_place = false
			return
	can_place = true
	



# Assign the slots to the item based on how much space it should take.
func set_grids(a_Slot):
	for grid in item_held.item_grids:
		var grid_to_check = a_Slot.slot_ID + grid[0] + grid[1] * col_count
		var line_switch_check = a_Slot.slot_ID % col_count + grid[0]
		if grid_to_check < 0 or grid_to_check >= grid_array.size():
			continue
		if line_switch_check < 0 or line_switch_check >= col_count:
			continue
		
		
		if can_place:
			grid_array[grid_to_check].set_color(grid_array[grid_to_check].States.FREE)
			
			if grid[1] < icon_anchor.x: icon_anchor.x = grid[1]
			if grid[0] < icon_anchor.y: icon_anchor.y = grid[0]
		else:
			grid_array[grid_to_check].set_color(grid_array[grid_to_check].States.TAKEN)

# Spawn an item when the button gets pressesd.
func _on_spawn_item_pressed() -> void:
	var new_item = item_scene.instantiate()
	add_child(new_item)
	new_item.load_item(3)
	new_item.selected = true
	item_held = new_item



# The grid should be at default (empty) when a space isn't occupied.
# This only occurs when dragging and placing items.
func clear_grid():
	for grid in grid_array:
		grid.set_color(grid.States.DEFAULT)


# Rotate the item 90 degrees clockwise.
func rotate_item():
	item_held.rotate_item()
	clear_grid()
	if current_slot:
		_on_slot_mouse_entered(current_slot)

# Place the item on the grid on according slots.
# If the item is being placed in the occupied space, the game will prevent the item from being placed on said spot.
func place_item():
	if not can_place or not current_slot:
		return
	var calculate_grid_id = current_slot.slot_ID + icon_anchor.x * col_count + icon_anchor.y
	item_held._snap_to(grid_array[calculate_grid_id].global_position)
	
	item_held.grid_anchor = current_slot
	for grid in item_held.item_grids:
		var grid_to_check = current_slot.slot_ID + grid[0] + grid[1] * col_count
		grid_array[grid_to_check].state = grid_array[grid_to_check].States.TAKEN
		grid_array[grid_to_check].item_stored = item_held
		
	item_held = null
	clear_grid()


# Grab an item that has been placed on the grid.
func pick_item():
	if not current_slot or not current_slot.item_stored:
		return
	
	item_held = current_slot.item_stored
	item_held.selected = true
	
	for grid in item_held.item_grids:
		var grid_to_check = item_held.grid_anchor.slot_ID + grid[0] + grid[1] * col_count
		grid_array[grid_to_check].state = grid_array[grid_to_check].States.FREE
		
	check_slot_availability(current_slot)
	set_grids.call_deferred(current_slot)
	
	
	
