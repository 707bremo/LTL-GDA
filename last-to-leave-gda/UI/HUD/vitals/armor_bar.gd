extends TextureProgressBar



var armor = 0 : set = _set_armor



func _set_armor(new_armor):
	var prev_armor = armor
	armor = min(max_value, new_armor)
	value = armor
	
	if armor <= 0:
		queue_free()

func init_armor(_armor):
	armor = _armor
	max_value = armor
	value = armor
