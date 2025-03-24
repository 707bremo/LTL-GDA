extends Resource
class_name ItemData

@export var name: String = ""
@export_multiline var description: String = ""
@export var stackable: bool = false
@export var object: Texture
@export var weight: float

func use(target) -> void:
	pass
