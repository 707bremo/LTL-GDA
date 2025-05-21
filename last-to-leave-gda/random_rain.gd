extends GPUParticles3D

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var show_rain = rng.randi_range(1, 100)
	if show_rain >= 86:
		visible = true
	else:
		visible = false
