extends ItemData
class_name ItemDataWeapon


@export var max_ammo: int
@export var ammo_type: String
@export var mesh : Mesh
@export_category("Weapon Sway")
@export var sway_min : Vector2 = Vector2(-20.0, -20.0)
@export var sway_max : Vector2 = Vector2(20.0, 20.0)
@export_range(0, 0.2, 0.01) var sway_speed_position : float = 0.07
@export_range(0, 0.2, 0.01) var sway_speed_rotation : float = 0.1
@export_range(0, 0.25, 0.01) var sway_amount_position : float = 0.1
@export_range(0, 50, 0.01) var sway_amount_rotation : float = 30.0
@export_category("Weapon Orientation")
@export var position : Vector3
@export var rotation : Vector3
@export var shooting_sound : AudioStreamWAV
