extends Panel

var item = null  # Holds item data when an item is placed

func set_item(new_item):
	item = new_item
	update_visual()

func update_visual():
	if item:
		modulate = Color(1, 1, 1, 1)  # Fully visible if the space is occupied
	else:
		modulate = Color(1, 1, 1, 0.5)  # Semi-transparent when the space is empty
