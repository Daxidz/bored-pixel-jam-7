extends Node

const Room = preload("res://World/Room.tscn")

const MAX_SIZE = 300
const MIN_SIZE = 150


const MAP_ROOM_SIZE = 50

enum Directions {UP, DOWN, LEFT, RIGHT}

var rooms_drawned = []

var rooms_ = []


func draw_map():
	var room = $Rooms.get_child(0)
	
	if not rooms_drawned.has(room)
		draw
	




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
	
	while not valid:
		candidate_neigh = $Rooms.get_child(randi() % cur_nb)
		direction = Directions.values()[randi() % Directions.size()]
		valid = validate_room(candidate_neigh, direction)
	
	candidate_neigh.neighbors[int(direction)] = _room
	_room.neighbors[int(direction)+2%4] = candidate_neigh
	

	
	
func validate_room(room, direction) -> bool:
	var valid = false
	valid = room.neighbors[int(direction)] == null
#	match direction:
#		Directions.UP:
#			valid = room.up_neigh
#		Directions.DOWN:
#			valid = room.down_neigh
#		Directions.LEFT:
#			valid = room.left_neigh
#		Directions.RIGHT:
#			valid = room.right_neigh
			
	return valid
	
func create_dungeon(nb_rooms):
	print("Initially spawning ", nb_rooms, " rooms.")
	for i in nb_rooms:
		_generate_room()
	pass
	
func destroy_dungeon():
	for room in $Rooms.get_children():
		room.queue_free()