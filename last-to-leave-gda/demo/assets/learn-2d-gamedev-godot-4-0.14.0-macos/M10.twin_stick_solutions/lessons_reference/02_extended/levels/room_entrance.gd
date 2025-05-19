@tool
class_name RoomEntrance extends Area2D

signal player_entered

@onready var _collider := $StaticBody2D/CollisionShape2D as CollisionShape2D
@onready var _animation_player := $AnimationPlayer as AnimationPlayer


func _ready() -> void:
	body_entered.connect(func (body: Node) -> void:
		player_entered.emit()
	)
	_animation_player.play("RESET")


func open() -> void:
	_collider.set_deferred("disabled", true)
	_animation_player.play_backwards("close")


func close() -> void:
	_collider.set_deferred("disabled", false)
	_animation_player.play("close")
