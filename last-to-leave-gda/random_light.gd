extends WorldEnvironment

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var random_energy = rng.randf_range(0.1, 1.0)
	self.environment.background_energy_multiplier = random_energy
