extends RigidBody3D

@export var outline: MeshInstance3D
@export var slot_data: SlotData


@onready var item_mesh: Sprite3D = $Sprite3D



func _ready() -> void:
	item_mesh.texture = slot_data.item_data.object

func _physics_process(delta: float) -> void:
	item_mesh.rotate_y(delta)

func _on_interaction_area_body_entered(body: Node3D) -> void:
	if body.inventory_data.pick_up_slot_data(slot_data):
		queue_free()
