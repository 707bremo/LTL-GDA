extends Node3D
var door_opened = false
signal door_interacted

func _on_door_interacted() -> void:
	print("Door interacted with!")
	if door_opened == true:
		print("open")
	elif door_opened == false:
		print("closed")
