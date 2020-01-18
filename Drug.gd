extends Area2D

func _on_Drug_body_entered(body):
	if body.name == "Player":
		body.take_drug(self)
		self.queue_free()
		
	pass # Replace with function body.
