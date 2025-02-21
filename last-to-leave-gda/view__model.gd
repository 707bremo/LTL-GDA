extends Camera3D
@onready var fps_rig: Node3D = $fps_rig
@onready var animation_player: AnimationPlayer = $fps_rig/shotgun/AnimationPlayer
var shotgun_in_use = true; 

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	fps_rig.position.x = lerp(fps_rig.position.x, 0.0, delta * 5)
	fps_rig.position.y = lerp(fps_rig.position.y, 0.0, delta * 5)

func sway(sway_amount):
	fps_rig.position.x -= sway_amount.x * 0.00005
	fps_rig.position.y += sway_amount.y * 0.00005

func _input(event):
	if(event.is_action_pressed("shoot")):
		animation_player.play("fire")
	
	if(event.is_action_pressed("reload")):
		animation_player.play("reload")
	
	if(event.is_action_pressed("use")):
		shotgun_in_use = !shotgun_in_use
		if(shotgun_in_use):
			animation_player.play("put_away")
		else:
			animation_player.play("pull_up")
	
