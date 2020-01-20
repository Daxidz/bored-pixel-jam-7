extends "res://World/drug/effects/effect.gd"

func apply_on_player(player):
	print("HP +2!")
	player.set_hp(player.hp+2)
	
func remove_from_player(player):
	pass