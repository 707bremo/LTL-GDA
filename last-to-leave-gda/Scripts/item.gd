# item.gd +++
extends Node2D

@onready var IconRect_path = $Icon

var item_ID : int
var item_grids := []
var selected = false
var grid_anchor = null



# Load one of the items based on the ones available in he data table.
func _ready() -> void:
	load_item(3)
	selected = true


# Selected determines if the item is in a held or not.
# Get the mouse position to keep the item aligned with the cursor.
func _process(delta: float) -> void:
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)


# Item data is loaded in based on the available asset in the folder.
func load_item(a_ItemID : int) -> void:
	var Icon_path = "res://AssetsIMG/" + DataHandler.item_data[str(a_ItemID)]["Name"] + ".png"
	IconRect_path.texture = load(Icon_path)
	for grid in DataHandler.item_grid_data[str(a_ItemID)]:
		var converter_array := []
		for i in grid:
			converter_array.push_back(int(i))
		item_grids.push_back(converter_array)
		Control.PRESET_CENTER

# The image itself rotates.
func rotate_item():
	for grid in item_grids:
		var temp_y = grid[0]
		grid[0] = -grid[1]
		grid[1] = temp_y
	rotation_degrees += 90
	if rotation_degrees >= 360:
		rotation_degrees = 0

# The item should snap to the closest part of the grid based on its anchor.
# If the anchor is too far from where the item is being dragged to, it'll anchor to the nearest slot.
func _snap_to(destination:Vector2):
	var tween = get_tree().create_tween()
	if int(rotation_degrees) % 180 == 0:
		destination += IconRect_path.size/2
	else:
		var temp_xy_switch = Vector2(IconRect_path.size.y, IconRect_path.size.x)
		destination += temp_xy_switch/2
	
	# Mini animation when the item is snapped using the tween properties.
	tween.tween_property(self, "global_position", destination, 0.15).set_trans(Tween.TRANS_SINE)
	selected = false
	
	
	
