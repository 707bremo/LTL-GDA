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
