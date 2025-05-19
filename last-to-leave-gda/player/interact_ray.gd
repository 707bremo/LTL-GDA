extends RayCast3D

var NearbyBodies : Containers


func _on_object_colliding(body: StaticBody3D):
	if (body is Containers):
		body.gain_highlight()

func _on_object_avert(body: StaticBody3D):
	if self != Containers:
		body.lose_highlight()
