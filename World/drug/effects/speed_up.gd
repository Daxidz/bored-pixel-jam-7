extends "res://World/drug/effects/effect.gd"

var base_speed

func apply_on_player(player):
	print("speeding the player speed up!!!")
	base_speed = player.max_speed
	player.max_speed *= 2
	
func remove_from_player(player):
	print("Speed going back to normal")
	player.max_speed = base_speed