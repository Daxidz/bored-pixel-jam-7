extends TileMap
onready var global = get_node("/root/global")

func _ready():
	
	var nb_tiles: Vector2 = get_parent().size_tiles
	
	print("The tilemap size is: ", nb_tiles)

	var height = nb_tiles.y
	var width = nb_tiles.x
	for i in width:
		for j in height:

			if i == 0 or j == 0 or j == height-1 or i == width - 1:
				set_cell(i, j, 1)
			else:
				pass
				#set_cell(i, j, 0)