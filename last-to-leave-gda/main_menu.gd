extends Control


func _ready() -> void:
	$MenuMusic.play()
	$AnimationPlayer.play("main_opening")
