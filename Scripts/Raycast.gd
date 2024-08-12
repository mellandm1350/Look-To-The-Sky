extends RayCast3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_colliding():
		var hit_object = get_collider()
		if hit_object.has_method("_interact") && Input.is_action_just_pressed("interact"):
			print("opn")
			hit_object._interact()
