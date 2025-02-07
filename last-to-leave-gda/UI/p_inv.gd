extends GridContainer

@export var slot_count: int = 30  # Adjust the number of slots
@export var slot_scene: PackedScene  # Assign a Slot.tscn scene in the editor

func _ready():
	for i in range(slot_count):
		var slot_instance = slot_scene.instantiate()
		add_child(slot_instance)
