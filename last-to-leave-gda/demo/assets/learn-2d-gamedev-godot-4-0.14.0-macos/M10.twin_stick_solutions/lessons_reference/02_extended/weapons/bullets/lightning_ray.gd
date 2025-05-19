extends Bullet

@onready var _sprite := $Sprite2D
@onready var _particles := $GPUParticles2D


func _ready() -> void:
	body_entered.connect(func (body: Node) -> void:
		hit_body(body)

		audio_stream_player.play()

		_sprite.hide()
		_particles.emitting = true
		speed = 0.0

		await audio_stream_player.finished
		queue_free()
	)
