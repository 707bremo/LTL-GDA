extends Control

@onready var inventories: Control = $/root/World/Inventories


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_inventory") and inventories.visible == false:
		inventories.visible = true
	elif Input.is_action_just_pressed("open_inventory") and inventories.visible == true:
		inventories.visible = false
