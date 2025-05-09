extends Node3D

@onready var enemy = get_parent()
@onready var bullet_scene = preload("res://bullet.tscn")  
@onready var shoot_timer: Timer = $Enemy_shoot_timer 
@onready var enemy_shot: AudioStreamPlayer3D = $enemy_shot
var can_shoot := true

func _ready() -> void:
	enemy.attack_player.connect(shoot_bullet)

func shoot_bullet():
	if not can_shoot:
		return 
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet) 
	self.add_to_group("bullets")
	bullet.global_position = global_position  
	var player = PlayerManager.player  
	bullet.target = player
	can_shoot = false
	shoot_timer.start()  
	enemy_shot.play()

func _on_enemy_shoot_timer_timeout() -> void:
	can_shoot = true  
