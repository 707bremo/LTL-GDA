@tool

extends Node3D

@export var WEAPON_TYPE : ItemDataWeapon#:
	#set(value):
		#WEAPON_TYPE = value
		#if Engine.is_editor_hint():
			#load_weapon()

@onready var weapon_mesh : MeshInstance3D = %WeaponMesh

var mouse_movement : Vector2

func _ready() -> void:
	await owner.ready
	WEAPON_TYPE = load("res://UI/HUD/Inventory/item/weapons/NoWeapon/no_weapon.tres")
	load_weapon()


func _input(event):
	if event.is_action_pressed("draw_weapon1"):
		WEAPON_TYPE = load("res://UI/HUD/Inventory/item/weapons/M4A1/m4a1.tres")
		load_weapon()
	
	if event.is_action_pressed("withdraw_weapon"):
		WEAPON_TYPE = load("res://UI/HUD/Inventory/item/weapons/NoWeapon/no_weapon.tres")
		load_weapon()
	
	if event is InputEventMouseMotion:
		mouse_movement = event.relative

func load_weapon() -> void:
	weapon_mesh.mesh = WEAPON_TYPE.mesh
	position = WEAPON_TYPE.position
	rotation_degrees = WEAPON_TYPE.rotation

func sway_weapon(delta) -> void:
	mouse_movement = mouse_movement.clamp(WEAPON_TYPE.sway_min, WEAPON_TYPE.sway_max)
	
	position.x = lerp(position.x, WEAPON_TYPE.position.x - (mouse_movement.x * 
WEAPON_TYPE.sway_amount_position) * delta, WEAPON_TYPE.sway_speed_position)
	position.y = lerp(position.y, WEAPON_TYPE.position.y + (mouse_movement.y * 
WEAPON_TYPE.sway_amount_position) * delta, WEAPON_TYPE.sway_speed_position)

	rotation_degrees.x = lerp(rotation_degrees.x, WEAPON_TYPE.rotation.x - (mouse_movement.y * 
WEAPON_TYPE.sway_amount_rotation) * delta, WEAPON_TYPE.sway_speed_rotation)
	rotation_degrees.y = lerp(rotation_degrees.y, WEAPON_TYPE.rotation.y + (mouse_movement.x * 
WEAPON_TYPE.sway_amount_rotation) * delta, WEAPON_TYPE.sway_speed_rotation)



func _physics_process(delta: float) -> void:
	sway_weapon(delta)
