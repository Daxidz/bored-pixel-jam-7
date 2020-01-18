extends "res://World/drug/effects/effect.gd"

var scale_base

func apply_on_player(player):
	print("slowing the player")
	scale_base = player.scale 
	player.scale /= 2
	
func remove_from_player(player):
	print("Speed going back to normal")
	player.scale = scale_base