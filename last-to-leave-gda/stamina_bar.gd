extends ProgressBar


var stamina = 0 : set = _set_stamina



func _set_stamina(new_stamina):
	var prev_stamina = stamina
	stamina = min(max_value, new_stamina)
	value = stamina

func init_stamina(_stamina):
	stamina = _stamina
	max_value = stamina
	value = stamina
