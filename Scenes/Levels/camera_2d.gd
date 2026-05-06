extends Camera2D

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		body.is_living = false
		print("player death")
