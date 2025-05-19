extends Node2D

var weapon: Weapon = null: set = set_weapon
var use_controller := false

@onready var _weapon_anchor: Marker2D = $WeaponAnchor

@onready var _weapon: Weapon = null
@onready var _hand_left: Sprite2D = $WeaponAnchor/HandLeft
@onready var _hand_right: Sprite2D = $WeaponAnchor/HandRight


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion or event is InputEventKey:
		use_controller = false
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		use_controller = true


func _process(_delta: float) -> void:
	var aim_direction := Vector2.ZERO
	if use_controller:
		aim_direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	else:
		aim_direction = global_position.direction_to(get_global_mouse_position())
	if aim_direction.length() > 0.1:
		rotation = aim_direction.angle()

	z_index = 3
	if aim_direction.y < 0.0:
		z_index = 1


func set_weapon(new_weapon: Weapon) -> void:
	# This is somewhat new, swapping instances
	if _weapon != null:
		_weapon_anchor.remove_child(_weapon)
		_weapon.queue_free()

	_weapon = new_weapon
	_weapon_anchor.add_child(_weapon)


func set_hand_texture(hand_texture: Texture2D) -> void:
	_hand_left.texture = hand_texture
	_hand_right.texture = hand_texture
