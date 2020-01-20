extends "res://World/drug/effects/effect.gd"

var base_hp

func apply_on_player(player):
	print("HP to 1!")
	base_hp = player.hp
	player.set_hp(1)
	
func remove_from_player(player):
	print("HP going back to normal (", base_hp, ")")
	player.set_hp(base_hp)