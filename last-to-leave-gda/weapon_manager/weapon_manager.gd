class_name WeaponManager
extends Node3D

@export var current_weapon : WeaponResource

@export var player : CharacterBody3D
@export var bullet_raycast : RayCast3D
@export var view_model_container : Node3D
@export var world_model_container : Node3D

var current_weapon_view_model : Node3D
var current_weapon_world_model : Node3D

func update_weapon_model() -> void:
	if current_weapon != null:
		if view_model_container and current_weapon.view_model:
			current_weapon_view_model = current_weapon.view_model.instantiate()
			#view_model_container.add_child(current_weapon.view_model)

func _ready() -> void:
	update_weapon_model()
	
func _process(delta: float) -> void:
	pass
