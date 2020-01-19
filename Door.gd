extends Area2D

onready var global = get_node("/root/global")

signal switch_to_room

var id_neighboor = -1

var orientation


func _on_Door_body_entered(body):
	if body.get_name() == "Player":
		emit_signal("switch_to_room", self)
