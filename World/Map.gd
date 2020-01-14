extends Node2D

const MAP_ROOM_SIZE = Vector2(80, 80)

var rooms_pos = []

func _draw():
	for room_pos in rooms_pos:
		print("drawing rect at: ", room_pos)
		draw_rect(Rect2(room_pos, MAP_ROOM_SIZE), Color(64, 0, 64), false)
	pass
	
func add_room_pos(room_pos):
	if not rooms_pos.has(room_pos):
		rooms_pos.push_back(room_pos)
		update()