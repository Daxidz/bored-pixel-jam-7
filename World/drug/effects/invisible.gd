extends "res://World/drug/effects/effect.gd"

var base_modulate

func apply_on_player(player):
	print("invisible")
	base_modulate = player.get_node("Sprite").modulate
	player.get_node("Sprite").modulate = Color("#17ffffff")
	
func remove_from_player(player):
	print("visible")
	player.get_node("Sprite").modulate = base_modulate