extends "res://World/drug/effects/effect.gd"

var scale_base

func apply_on_player(player):
	print("scaling down the player")
	scale_base = player.scale 
	player.scale *= 1.5
	
func remove_from_player(player):
	print("scale back")
	player.scale = scale_base