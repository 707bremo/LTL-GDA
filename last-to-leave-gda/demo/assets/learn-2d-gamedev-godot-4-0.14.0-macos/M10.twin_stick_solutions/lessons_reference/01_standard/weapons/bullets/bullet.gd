class_name Bullet_01 extends Area2D

@export var audio_stream_player: AudioStreamPlayer2D = null
@export var speed := 750
@export var damage := 1

var max_range := 1000.0

var _travelled_distance = 0.0


func _ready() -> void:
	assert(
		audio_stream_player != null,
		"The audio_stream_player property is not set for the bullet at path " + str(get_path()) + ". " +
		"The bullet needs an AudioStreamPlayer2D node to play audio when it hits something. Set it in the Inspector."
	)
	body_entered.connect(func (body: Node) -> void:
		hit_body(body)
		_destroy()
	)


func _physics_process(delta: float) -> void:
	var distance := speed * delta
	var motion := transform.x * speed * delta

	position += motion

	_travelled_distance += distance
	if _travelled_distance > max_range:
		_destroy()


func hit_body(body: Node) -> void:
	if body is Mob_01:
		body.health -= damage


func _destroy():
	queue_free()
