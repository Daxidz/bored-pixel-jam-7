extends "res://World/drug/effects/effect.gd"

var VisionReduced = preload("res://World/drug/effects/VisionReduced.tscn")
var vision_reduce_sprite


func apply_on_player(player):
	var hud = player.get_node("/root/Main/GameManager/HUD")
	vision_reduce_sprite = VisionReduced.instance()
	hud.add_child(vision_reduce_sprite)
	
func remove_from_player(player):
	var hud = player.get_node("/root/Main/GameManager/HUD")
	hud.remove_child(vision_reduce_sprite)
	vision_reduce_sprite.queue_free()