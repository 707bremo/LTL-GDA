extends Node3D
class_name InteractableItem

@export var ItemHighlightMesh : MeshInstance3D

func GainFocus():
	ItemHighlightMesh = true


func LoseFocus():
	ItemHighlightMesh = false
