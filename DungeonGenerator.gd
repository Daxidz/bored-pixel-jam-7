extends Node

const Room = preload("res://World/Room.tscn")

const MAX_SIZE = 300
const MIN_SIZE = 150

const MAP_ROOM_SIZE = 80

enum Directions {UP, RIGHT, DOWN, LEFT}

var rooms_drawned = []

var rooms_ = []

var cur_index = Vector2(0, 0)




#func draw_map():
#	var room = $Rooms.get_child(0)
#
#	if not rooms_drawned.has(room):
#		$Map.add_room_pos(cur_index)


func init():
    $Map.clear()

func _generate_room():
    var room = Room.instance()

    var height = randi() % MAX_SIZE + MIN_SIZE
    var width = randi() % MAX_SIZE + MIN_SIZE

    var size = Vector2(height, width)

    room.set_size(size)
    room.id = $Map.rooms.size()

    add_room(room)

    $Rooms.add_child(room)


func add_room(_room):
    var candidate_neigh
    var direction
    var cur_nb = $Map.rooms.size()
    var valid = false

    # Check for the first room
    if cur_nb == 0:
        _room.pos_on_minimap = Vector2(0, 0)
        $Map.add_room(_room)
        return

    # Find a valid neighbors (room + direction relative to the room)
    while not valid:
        candidate_neigh = $Map.rooms[randi() % cur_nb]
        direction = Directions.values()[randi() % Directions.size()]
        valid = validate_room(candidate_neigh, direction)

    candidate_neigh.neighbors[int(direction)] = _room
    _room.neighbors[(int(direction)+2) % Directions.size()] = candidate_neigh

    var pos = candidate_neigh.pos_on_minimap
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
    $Map.add_room(_room)


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

func create_dungeon(nb_rooms):
    print("Initially spawning ", nb_rooms, " rooms.")
    for i in nb_rooms:
        _generate_room()
    pass

func destroy_dungeon():
    $Map.clear()
    print("Dungeon destroyed! Rooms left: ", $Rooms.get_child_count())
    assert ($Rooms.get_child_count() == 0)