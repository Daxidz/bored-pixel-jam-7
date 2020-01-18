extends Area2D

signal switch_to_room

var id_neighboor = -1


func _on_Door_body_entered(body):
	if body.get_name() == "Player":
		emit_signal("switch_to_room", id_neighboor)
