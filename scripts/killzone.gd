extends Area2D

func _on_body_entered(body):
	print("hi")
	print(body)
	if body.is_in_group("Player"):
		print("woah")
		body.respawn()
