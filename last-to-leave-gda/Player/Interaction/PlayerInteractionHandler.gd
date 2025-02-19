extends Area3D

@export var ItemTypes : Array[ItemData] = []
@onready var canvas_layer: CanvasLayer = $/root/TestRoom/Player/CanvasLayer

var NearbyBodies : Array[InteractableItem]

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("Interact")):
		PickupNearestItem()
		canvas_layer.visible = false


func PickupNearestItem():
	var nearestItem : InteractableItem = null
	var nearestItemDistance : float = INF
	for item in NearbyBodies:
		if (item.global_position.distance_to(global_position) < nearestItemDistance):
			nearestItemDistance = item.global_position.distance_to(global_position)
			nearestItem = item
	
	if (nearestItem != null):
		nearestItem.queue_free()
		NearbyBodies.remove_at(NearbyBodies.find(nearestItem))
		var itemPrefab = nearestItem.scene_file_path
		for i in ItemTypes.size():
			if (ItemTypes[i].ItemModelPrefab != null and ItemTypes[i].ItemModelPrefab.resource_path == itemPrefab):
				print("ID:" + str(i) + " Name: " + ItemTypes[i].ItemName)
				return
		
		
		printerr("No items Daga")

func OnObjectEnteredArea(body: Node3D):
	if (body is InteractableItem):
		canvas_layer.visible = true
		body.GainFocus()
		NearbyBodies.append(body)

func OnObjectExitedArea(body: Node3D):
	if (body is InteractableItem and NearbyBodies.has(body)):
		canvas_layer.visible = false
		body.LoseFocus()
		NearbyBodies.remove_at(NearbyBodies.find(body))
