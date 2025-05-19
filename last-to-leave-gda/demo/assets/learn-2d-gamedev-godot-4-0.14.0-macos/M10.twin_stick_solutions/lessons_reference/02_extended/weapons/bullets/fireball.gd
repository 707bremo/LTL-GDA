extends Bullet

@onready var _animation_player := $AnimationPlayer as AnimationPlayer
@onready var _particles := $GPUParticles2D as GPUParticles2D


func _ready() -> void:
	body_entered.connect(func (body: Node) -> void:
		hit_body(body)
		_destroy()
	)
	_animation_player.play("spawn")


func _destroy():
	set_physics_process(false)
	set_deferred("monitoring", false)
	_animation_player.play("destroy")
	audio_stream_player.play()
