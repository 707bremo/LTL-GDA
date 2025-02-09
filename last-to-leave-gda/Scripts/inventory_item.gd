@tool
extends Node3D



@export var item_name = ""
@export var item_type = ""
@export var item_description = ""



@onready var pickup_label: Label3D = $Pickup_label
var scene_path: String = "res://Scenes/inventory_item.tscn"
var player_in_range = false




func _ready() -> void:
	pass 


# If the player presses the "E" key, and is within range of the item, the player can pick it up
func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("ui_add"):
		pickup_item()




func pickup_item():
	var item = {
		"quantity" : 1,
		"item_name" : item_name,
		"item_type" : item_type,
		"item_description" : item_description,
		"scene_path" : scene_path,
	}
	if Global.player_node:
		Global.add_inventory_item(item)
		self.queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_in_range = true
		pickup_label.visible = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_in_range = false
		pickup_label.visible = false
