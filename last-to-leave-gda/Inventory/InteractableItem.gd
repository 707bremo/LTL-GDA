extends Node3D
class_name InteractableItem

@export var ItemHighlightMesh : MeshInstance3D
var item_data = {}

func GainFocus():
	ItemHighlightMesh.visible = true
func LoseFocus():
	ItemHighlightMesh.visible = false

func set_item_data(data: Dictionary):
	item_data = data
# Update the item's appearance or behavior based on the data
	print("Spawned item: ", item_data["name"])


func pick_up():
	var inventory = get_tree().get_first_node_in_group("inventory")
	if inventory:
		# Pass BOTH the item data and position before queue_free
		inventory.add_item_to_inventory({
			"id": item_data["id"],
			"name": item_data["name"],
			"texture_path": "res://AssetsIMG/" % item_data["name"]
		})
		# Delay removal to ensure inventory processing
		await get_tree().create_timer(0.1).timeout
		queue_free()
