extends GridContainer

@export var slot_count: int = 30  # The number of slots
@export var slot_scene: PackedScene

func _ready():
	for i in range(slot_count):
		var slot_instance = slot_scene.instantiate()
		add_child(slot_instance)
