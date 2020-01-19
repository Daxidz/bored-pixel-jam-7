extends Node

const Room: PackedScene = preload("res://World/Room.tscn")
var Drug: PackedScene = preload("res://World/drug/Drug.tscn")
var Bed: PackedScene = preload("res://World/Bed.tscn")

onready var helpers = get_node("/root/helpers")
onready var global = get_node("/root/global")

# Size in tiles
const MAX_NB_TILES = 15
const MIN_NB_TILES = 10

const MAX_SIZE = global.TILE_SIZE * MAX_NB_TILES
const MIN_SIZE = global.TILE_SIZE * MIN_NB_TILES

const MAX_ENEMIES = 5
const MIN_ENEMIES = 3

const MAX_OBSTACLES = 7
const MIN_OBSTACLES = 5

const MAP_ROOM_SIZE = 80

enum Orientations {NORTH, EAST, SOUTH, WEST}

# map path to id
var rooms = {}

var cur_index = Vector2(0, 0)




func init():
    $Map.clear()

func _generate_room():
	var room = Room.instance()
	
	var height: int = randi() % MAX_NB_TILES + MIN_NB_TILES
	var width: int = randi() % MAX_NB_TILES + MIN_NB_TILES
	
	var size = Vector2(height, width)
	
	room.set_size(size)
	
	room.id = $Map.rooms.size()
	# Check + create the 
	add_room(room)
	room.disable()
	add_room_to_map(room)
	add_obstacle_to_room(room)
	$Rooms.add_child(room)
	

func add_room_to_map(room):
	$Map.add_room(room)
	
# This function add 
func add_room(_room):
	var candidate_neigh
	var direction
	var cur_nb = $Rooms.get_child_count()
	var valid = false
	var pos
	
	for dir in Orientations.values():
		_room.neighbors[dir] = -1
		
	
	# Check for the first room
	if cur_nb == 0:
		pos = Vector2(0, 0)
	else:
		# Find a valid neighbors (room + direction relative to the room)
	    while not valid:
	        candidate_neigh = $Map.rooms[randi() % cur_nb]
	        direction = Orientations.values()[randi() % Orientations.size()]
	        valid = validate_room(candidate_neigh, direction)
	
	    candidate_neigh.neighbors[direction] = _room.id
	    _room.neighbors[(int(direction)+2) % Orientations.size()] = candidate_neigh.id
	    pos = candidate_neigh.pos_on_minimap
	    match direction:
	        Orientations.NORTH:
	            pos.y -= MAP_ROOM_SIZE+2
	        Orientations.SOUTH:
	            pos.y += MAP_ROOM_SIZE+2
	        Orientations.WEST:
	            pos.x -= MAP_ROOM_SIZE+2
	        Orientations.EAST:
	            pos.x += MAP_ROOM_SIZE+2
	
	_room.pos_on_minimap = pos
	
# TODO add all mobs
func populate_room(room):
	var nb = helpers.randi_limited(MIN_ENEMIES, MAX_ENEMIES)
	var position = Vector2.ZERO
	for i in nb:
		position.x = helpers.randi_limited(1, room.size_tiles.x-1)
		position.y = helpers.randi_limited(1, room.size_tiles.y-1)
		#position = Vector2(room.size_tiles.x/2, room.size_tiles.y/2)
		room.add_mob("kek", position)
		
		
func add_doors_to_rooms():
	for room in $Rooms.get_children():
		add_doors_to_room(room)
			
# TODO add all doors
func add_doors_to_room(room):
	for dir in Orientations.values():
		if room.neighbors[dir] != -1:
			room.add_door(dir, room.neighbors[dir])
	
	
func add_drug_to_room(room):
	var position = Vector2.ZERO
	var drug
	var valid = false
	while not valid:
		position.x = helpers.randi_limited(1, room.size_tiles.x-1)
		position.y = helpers.randi_limited(1, room.size_tiles.y-1)
		drug = Drug.instance()
		valid = room.add_drug(drug, position)
	
	
func add_obstacle_to_room(room):
	var positions
	var position = Vector2.ZERO
	var nb_obstacles = helpers.randi_limited(MIN_OBSTACLES, MAX_OBSTACLES)
	var valid = false
	
	for i in nb_obstacles:
		
		while not valid:
			position.x = helpers.randi_limited(2, room.size_tiles.x-2)
			position.y = helpers.randi_limited(2, room.size_tiles.y-2)
			var bed = Bed.instance()
			valid = room.add_bed(bed, position)
	

func validate_room(room, direction) -> bool:
    var count = room.neighbors.count(-1)
    var idir = int(direction)
    var size = Orientations.size()
	
    # No neighbor available
    if (count == 0):
        return false
		
    # Place is already taken
    if (room.neighbors[direction] != -1):
        return false
		
    var cur_pos = room.pos_on_minimap
    var new_pos = cur_pos
    match direction:
        Orientations.NORTH:
            new_pos.y -= MAP_ROOM_SIZE+2
        Orientations.SOUTH:
            new_pos.y += MAP_ROOM_SIZE+2
        Orientations.WEST:
            new_pos.x -= MAP_ROOM_SIZE+2
        Orientations.EAST:
            new_pos.x += MAP_ROOM_SIZE+2

    var left_dir = Orientations.values()[(idir + 1) % size]
    var right_dir = Orientations.values()[(idir - 1) % size]

    return check_pos(cur_pos, direction) and check_pos(new_pos, left_dir) and check_pos(new_pos, right_dir)
	

func check_pos(pos, direction):
    match direction:
        Orientations.NORTH:
            pos.y -= MAP_ROOM_SIZE+2
        Orientations.SOUTH:
            pos.y += MAP_ROOM_SIZE+2
        Orientations.WEST:
            pos.x -= MAP_ROOM_SIZE+2
        Orientations.EAST:
            pos.x += MAP_ROOM_SIZE+2

    return not $Map.exists(pos)


func create_dungeon(nb_rooms):
	print("Initially spawning ", nb_rooms, " rooms.")
	
	for i in nb_rooms:
		_generate_room()
	add_doors_to_rooms()
	for room in $Rooms.get_children():
		room.disable()
	
	
func destroy_dungeon():
	$Map.clear()
	rooms.clear()
	for room in $Rooms.get_children():
		room.free()
	print("Dungeon destroyed! Rooms left: ", $Rooms.get_child_count())
	assert ($Rooms.get_child_count() == 0)
	assert (rooms.size() == 0)
	
	
func get_room(id):
	return $Rooms.get_child(id)

# NOT USED FOT NOW. Needed for the dynamic loading of scene. To implement later
#func create_room_path(id):
#	return "res://rooms/room" + str(id) + ".tscn"
##
#func save_room(room):
#	var ps = PackedScene.new()
#	ps.pack(room)
#	ResourceSaver.save(rooms[room.id], ps)
#	var file2Check = File.new()
#	while not file2Check.file_exists(rooms[room.id]):
#		pass
#
#	room.free()
#
#
#func load_room(id):
#	var path = "res://rooms/room" + str(id) + ".tscn"
#	var room = ResourceLoader.load(path).instance()
#	return room
#