extends HBoxContainer

var Life = preload("res://actors/player/Life.tscn")


func update_hp(hp):
	
	for child in get_children():
		child.free()
		
	for i in hp:
		var life = Life.instance()
		add_child(life)