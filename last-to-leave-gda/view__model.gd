extends Camera3D
@onready var fps_rig: Node3D = $fps_rig
@onready var animation_player: AnimationPlayer = $fps_rig/shotgun/AnimationPlayer
@onready var gun_barrel = $fps_rig/shotgun/shotgun_model/RayCast3D
@onready var shoot_timer: Timer = $Shoot_timer  
@onready var shoot_sound: AudioStreamPlayer3D = $shoot_sound
@onready var shotgun_cock_back_sound: AudioStreamPlayer3D = $shotgun_cock_back_sound
@onready var holster_sound: AudioStreamPlayer3D = $holster_sound
@onready var muzzle_flash: GPUParticles3D = $fps_rig/shotgun/shotgun_model/muzzle_flash
var shotgun_in_use = true
var bullet = load("res://bullet.tscn")
var instance
var can_shoot = true  

func _ready() -> void:
	muzzle_flash.emitting = false 

func _process(delta: float) -> void:
	fps_rig.position.x = lerp(fps_rig.position.x, 0.0, delta * 5)
	fps_rig.position.y = lerp(fps_rig.position.y, 0.0, delta * 5)

func sway(sway_amount) -> void:
	fps_rig.position.x -= sway_amount.x * 0.00005
	fps_rig.position.y += sway_amount.y * 0.00005

func _input(event) -> void:
	if event.is_action_pressed("shoot") and can_shoot:
		can_shoot = false  
		animation_player.play("fire")
		muzzle_flash.emitting = true
		await get_tree().create_timer(0.05).timeout  
		muzzle_flash.emitting = false
		shoot_sound.play()
		instance = bullet.instantiate()
		instance.position = gun_barrel.global_position
		instance.transform.basis = gun_barrel.global_transform.basis
		get_parent().add_child(instance)
		await animation_player.animation_finished
		animation_player.play("shotgun_cock_back")
		shotgun_cock_back_sound.play()
		await animation_player.animation_finished
		can_shoot = true
