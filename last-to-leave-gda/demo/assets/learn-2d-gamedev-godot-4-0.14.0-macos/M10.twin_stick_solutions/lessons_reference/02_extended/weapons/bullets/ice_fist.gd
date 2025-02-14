extends Bullet

@onready var _sprite := $Sprite2D
@onready var _gpu_particles_2d: GPUParticles2D = %GPUParticles2D


func _ready() -> void:
	body_entered.connect(func (body: Node) -> void:
		hit_body(body)

		audio_stream_player.play()

		_sprite.hide()
		_gpu_particles_2d.emitting = false
		speed = 0.0

		await audio_stream_player.finished
		queue_free()
	)


func _physics_process(delta: float) -> void:
	super(delta)
	scale += Vector2.ONE * 2.0 * delta
