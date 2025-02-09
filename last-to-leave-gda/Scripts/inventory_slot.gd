extends Control


@onready var item_icon: Sprite2D = $Inside/ItemIcon
@onready var item_quantity: Label = $Inside/ItemQuantity
@onready var details_panel: ColorRect = $DetailsPanel
@onready var item_name: Label = $DetailsPanel/ItemName
@onready var item_desc: Label = $DetailsPanel/ItemDesc
@onready var item_type: Label = $DetailsPanel/ItemType
@onready var item_weight: Label = $DetailsPanel/ItemWeight

# Slot item
var item = null



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_item_button_pressed() -> void:
	pass

# If the cursor is hovering over an item, it will display the contents of the item
func _on_item_button_mouse_entered() -> void:
	if item != null:
		details_panel.visible = true

# If the cursor isn't hovering over an item, it won't display the contents of the item
func _on_item_button_mouse_exited() -> void:
	details_panel.visible = true


func set_empty():
	item_icon.texture = null
	item_quantity.text = ""


func set_item(new_item):
	item = new_item
	item_quantity.text = str(item["quantity"])
	item_name.text = str(item["item_name"])
	item_desc.text = str(item["item_description"])
	item_type.text = str(item["item_type"])
	
