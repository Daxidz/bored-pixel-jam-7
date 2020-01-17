extends Node

const Room: PackedScene = preload("res://World/Room.tscn")

onready var helpers = get_node("/root/helpers")
onready var global = get_node("/root/global")

# Size in tiles
const MAX_NB_TILES = 10
const MIN_NB_TILES = 5

const MAX_SIZE = global.TILE_SIZE * MAX_NB_TILES
const MIN_SIZE = global.TILE_SIZE * MIN_NB_TILES

const MAX_ENEMIES = 7
const MIN_ENEMIES = 3

const MAP_ROOM_SIZE = 80

enum Directions {UP, RIGHT, DOWN, LEFT}


var rooms = []

var cur_index = Vector2(0, 0)




func init():
    $Map.clear()

func _generate_room():
	var room = Room.instance()
	
	var height: int = randi() % MAX_NB_TILES + MIN_NB_TILES
	var width: int = randi() % MAX_NB_TILES + MIN_NB_TILES
	
	var size = Vector2(height, width)
	
	room.set_size(size)
	
	# Check + create the 
	add_room(room)

	room.id = $Map.rooms.size()
	
	populate_room(room)
	
	$Map.add_room(room)
	
	#_room.visible = false
	rooms.push_back(room)
	
	print(rooms)
	
	$Rooms.add_child(room)
	

# This function add 
func add_room(_room):
	var candidate_neigh
	var direction
	var cur_nb = rooms.size()
	var valid = false
	var pos
	
	_room.neighbors.resize(4)
	
	# Check for the first room
	if cur_nb == 0:
		print("First room added!")
		pos = Vector2(0, 0)
	else:
		# Find a valid neighbors (room + direction relative to the room)
	    while not valid:
	        candidate_neigh = $Map.rooms[randi() % cur_nb]
	        direction = Directions.values()[randi() % Directions.size()]
	        valid = validate_room(candidate_neigh, direction)
	
	    candidate_neigh.neighbors[int(direction)] = _room
	    _room.neighbors[(int(direction)+2) % Directions.size()] = candidate_neigh
	
	    pos = candidate_neigh.pos_on_minimap
	    match direction:
	        Directions.UP:
	            pos.y -= MAP_ROOM_SIZE+2
	        Directions.DOWN:
	            pos.y += MAP_ROOM_SIZE+2
	        Directions.LEFT:
	            pos.x -= MAP_ROOM_SIZE+2
	        Directions.RIGHT:
	            pos.x += MAP_ROOM_SIZE+2
	
	_room.pos_on_minimap = pos

	
func populate_room(room):
	var nb = helpers.randi_limited(MIN_ENEMIES, MAX_ENEMIES)
	var position = Vector2.ZERO
	for i in nb:
		position.x = helpers.randi_limited(1, room.size_tiles.x-1)
		position.y = helpers.randi_limited(1, room.size_tiles.y-1)
		room.add_mob("kek", position)
	
	
func validate_room(room, direction) -> bool:
    var count = room.neighbors.count(null)
    var idir = int(direction)
    var size = Directions.size()

    # No neighbor available
    if (count == 0):
        return false

    # Place is already taken
    if (room.neighbors[idir] != null):
        return false

    var cur_pos = room.pos_on_minimap
    var new_pos = cur_pos
    match direction:
        Directions.UP:
            new_pos.y -= MAP_ROOM_SIZE+2
        Directions.DOWN:
            new_pos.y += MAP_ROOM_SIZE+2
        Directions.LEFT:
            new_pos.x -= MAP_ROOM_SIZE+2
        Directions.RIGHT:
            new_pos.x += MAP_ROOM_SIZE+2

    var left_dir = Directions.values()[(idir + 1) % size]
    var right_dir = Directions.values()[(idir - 1) % size]

    return check_pos(cur_pos, direction) and check_pos(new_pos, left_dir) and check_pos(new_pos, right_dir)
	

func check_pos(pos, direction):
    match direction:
        Directions.UP:
            pos.y -= MAP_ROOM_SIZE+2
        Directions.DOWN:
            pos.y += MAP_ROOM_SIZE+2
        Directions.LEFT:
            pos.x -= MAP_ROOM_SIZE+2
        Directions.RIGHT:
            pos.x += MAP_ROOM_SIZE+2

    return not $Map.exists(pos)


func create_dungeon(nb_rooms):
	print("Initially spawning ", nb_rooms, " rooms.")
	
	# TODO: NOT USE THIS BUT THIS IS DEBUGGING
#	_generate_room()
#	return
	
	for i in nb_rooms:
		_generate_room()
	pass
	
func destroy_dungeon():
	$Map.clear()
	rooms.clear()
	for room in $Rooms.get_children():
		room.free()
	print("Dungeon destroyed! Rooms left: ", $Rooms.get_child_count())
	assert ($Rooms.get_child_count() == 0)
	assert (rooms.size() == 0)
