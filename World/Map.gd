extends Node2D

const MAP_ROOM_SIZE = Vector2(80, 80)

var rooms = []

func _draw():
	var label = Label.new()
	var font = label.get_font("")
	var i = 1
	for room in rooms:
		print("drawing rect at: ", room.pos_on_minimap)
		draw_rect(Rect2(room.pos_on_minimap, MAP_ROOM_SIZE), Color(64, 0, 64), false)
		var char_pos = Vector2(room.pos_on_minimap.x, room.pos_on_minimap.y)
		char_pos.x = char_pos.x + (MAP_ROOM_SIZE.x/2)
		char_pos.y = char_pos.y + (MAP_ROOM_SIZE.y/2)
		draw_string(font, char_pos, String(i), Color(64, 0, 64))
		i += 1
	label.free()
	pass
	
func add_room(room):
	if not rooms.has(room):
		rooms.push_back(room)
		update()