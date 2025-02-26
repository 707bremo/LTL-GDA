# item.gd +++
extends TextureRect

@onready var IconRect_path = $Icon

var item_ID : int
var item_grids := []
var selected = false
var grid_anchor = null



# Selected determines if the item is in a held or not.
# Get the mouse position to keep the item aligned with the cursor.
func _process(delta: float) -> void:
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)


func load_item(item_data: Dictionary):
	# Load texture directly from data
	IconRect_path.texture = load(item_data["texture_path"])
	
	# Get grid data from DataHandler
	if DataHandler.item_grid_data.has(item_data["id"]):
		item_grids = DataHandler.item_grid_data[item_data["id"]].duplicate()

func _snap_to(destination: Vector2):
	var tween = get_tree().create_tween()
	position = destination - IconRect_path.size/2  # Center on slot
	visible = true



# The image itself rotates.
func rotate_item():
	for grid in item_grids:
		var temp_y = grid[0]
		grid[0] = -grid[1]
		grid[1] = temp_y
	rotation_degrees += 90
	if rotation_degrees >= 360:
		rotation_degrees = 0
