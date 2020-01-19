extends "res://World/drug/effects/effect.gd"

var scale_base

func apply_on_player(player):
	print("scale the player down")
	scale_base = player.scale 
	player.scale /= 2
	
func remove_from_player(player):
	print("scale going back to normal")
	player.scale = scale_base