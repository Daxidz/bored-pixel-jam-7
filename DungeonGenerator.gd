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
	$Map.rooms_pos.clear()

func _generate_room():
	var room = Room.instance()
	
	var height = randi() % MAX_SIZE + MIN_SIZE
	var width = randi() % MAX_SIZE + MIN_SIZE
	
	var size = Vector2(height, width)
	
	room.set_size(size)
	
	add_room(room)
	
	$Rooms.add_child(room)
	

func add_room(_room):
	var candidate_neigh
	var direction
	var cur_nb = $Rooms.get_child_count()
	var valid = false
	
	_room.neighbors.resize(4)
	
	# Check for the first room
	if cur_nb == 0:
		print("First room added!")
		_room.pos_on_minimap = Vector2(0, 0)
		$Map.add_room_pos(Vector2(0, 0))
		return
	
	# Find a valid neighbors (room + direction relative to the room)
	while not valid:
		candidate_neigh = $Rooms.get_child(randi() % cur_nb)
		direction = Directions.values()[randi() % Directions.size()]
		valid = validate_room(candidate_neigh, direction)
	
	candidate_neigh.neighbors[int(direction)] = _room
	_room.neighbors[(int(direction)+2)%4] = candidate_neigh
	
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
	$Map.add_room_pos(pos)
	

	
	
func validate_room(room, direction) -> bool:
	print(room.neighbors.count(null))
	if room.neighbors.count(null) <= 1:
		return false
#	match direction:
#		Directions.UP:
#			valid = room.up_neigh
#		Directions.DOWN:
#			valid = room.down_neigh
#		Directions.LEFT:
#			valid = room.left_neigh
#		Directions.RIGHT:
#			valid = room.right_neigh
			
	return room.neighbors[int(direction)] == null
	
func create_dungeon(nb_rooms):
	print("Initially spawning ", nb_rooms, " rooms.")
	for i in nb_rooms:
		_generate_room()
	pass
	
func destroy_dungeon():
	for room in $Rooms.get_children():
		room.free()
	print("Dungeon destroyed! Rooms left: ", $Rooms.get_child_count())