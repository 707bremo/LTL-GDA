extends RayCast3D

var NearbyBodies : Containers


func _on_object_colliding(body):
	if (body is StaticBody3D and Containers):
		body.gain_highlight()

func _on_object_avert(body):
	if self != Containers and body is StaticBody3D:
		body.lose_highlight()
