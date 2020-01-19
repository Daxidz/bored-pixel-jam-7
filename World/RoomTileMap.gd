extends TileMap
onready var global = get_node("/root/global")

onready var room_size = get_parent().size_tiles

func _ready():
	
	print("The tilemap size is: ", room_size)

	var height = room_size.y
	var width = room_size.x
	for i in width:
		for j in height:
			if i == 0 or j == 0 or j == height-1 or i == width - 1:
				place_wall(Vector2(i, j))
			else:
				place_floor(Vector2(i, j))

func place_floor(pos):
	var flip_v = false
	var tile = tile_set.find_tile_by_name("floor")
	var rand_1 = randi()
	if rand_1 % 30 == 0:
		var rand_2 = randi()
		if rand_2 % 3 == 0:
			tile = tile_set.find_tile_by_name("floor_puke")
		else:
			tile = tile_set.find_tile_by_name("floor_blood")
		flip_v = rand_1 % 2 == 0
	
	set_cell(pos.x, pos.y, tile, flip_v)

func place_wall(pos):
	var tile
	
	var flip_v = false
	var flip_h = false
	var transpose = false
	
	if is_corner(pos):
		tile = tile_set.find_tile_by_name("wall_corner")
		flip_v = pos.y == room_size.y-1
		flip_h = pos.x == 0
	else:
		if randi() % 4 == 0:
			tile = tile_set.find_tile_by_name("wall_window")
		else:
			tile = tile_set.find_tile_by_name("wall")
			
		transpose = pos.x == 0 or pos.x == room_size.x-1
		flip_h = pos.x == room_size.x-1
		flip_v = pos.y == room_size.y-1
	set_cell(pos.x, pos.y, tile, flip_h, flip_v, transpose)

func is_corner(pos):
	return pos == Vector2(0,0) or pos == Vector2(0, room_size.y-1) or pos == Vector2(room_size.x-1, 0) or pos == Vector2(room_size.x-1, room_size.y-1)
#
#func _get_subtile_coord(id):
#	var tiles = tile_set
#	print(tile_set.get_tiles_ids())
#	var rect = tile_set.tile_get_region(id)
#	var x = randi() % int(rect.size.x / tiles.autotile_get_size(id).x)
#	var y = randi() % int(rect.size.y / tiles.autotile_get_size(id).y)
#	return Vector2(x, y)