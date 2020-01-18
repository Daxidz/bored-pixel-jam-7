extends Area2D

onready var helpers = get_node("/root/helpers")
onready var global = get_node("/root/global")
var Mob = preload("res://Mob.tscn")
var Door = preload("res://Door.tscn")

export var size_tiles: Vector2 = Vector2.ZERO
enum Orientations {NORTH, EAST, SOUTH, WEST}


export var show_border: bool = false

const MAP_SIZE = 50

var id: int = -1

# A room can only be non visited once, when the player
# first enters it
var visited = false
var cleared = false

# Dictionary of neighbors which contain the id and the direction of
# the neighbors rooms
# ex: { 1, Direction.NORTH } 
var neighbors = []

var drawn = false

var pos_on_minimap

func _init():
	self.neighbors.resize(4)
	pass

func _ready():
	print("Room with tilesize", size_tiles, " ready")

	
# Add mobs to the Room
# types is an array of types
func add_mob(type, pos):
	var mob = Mob.instance()
	mob.position = pos * 32
	$Mobs.add_child(mob)

func set_size(size):
    self.size_tiles = size
	

func add_door(direction, id_neighboor):
	var door = Door.instance()
	
	var pos = Vector2.ZERO
	
	match direction:
		Orientations.NORTH:
			pos.x += size_tiles.x/2
		Orientations.SOUTH:
			pos.y += size_tiles.y - 1
			pos.x += int(size_tiles.x/2)
			door.get_node("Sprite").flip_v = true
		Orientations.WEST:
			pos.y += size_tiles.y/2
			door.rotation_degrees = -90
		Orientations.EAST:
			pos.y += int(size_tiles.y/2)
			pos.x += size_tiles.x
			door.rotation_degrees = 90
			
	# Place door and init its neighbor_id
	door.position = pos * 32
	door.id_neighboor = id_neighboor
	# The switch_to_room signal is emitted when the door is enterd by the player
	# We connect it to the GameManager to let it manage what should happen
	door.connect("switch_to_room", get_node("/root/Main/GameManager"), "change_room")
	$Doors.add_child(door)
	
func add_drug(drug, pos):
	drug.position = pos * 32
	add_child(drug)
	
	
func disable():
	$TileMap.set_collision_layer_bit(0, false)
	$TileMap.set_collision_layer_bit(1, true)
	$TileMap.set_collision_mask_bit(0, false)
	$TileMap.set_collision_mask_bit(1, true)
	set_collision_layer_bit(0, false)
	set_collision_layer_bit(1, true)
	
	for door in $Doors.get_children():
		door.set_collision_layer_bit(0, false)
		door.set_collision_layer_bit(1, true)
		door.set_collision_mask_bit(0, false)
		door.set_collision_mask_bit(1, true)
		door.visible = false
#		door.get_node("Sprite").modulate = Color("#f40707")
		
	visible = false
	
func enable():
	$TileMap.set_collision_layer_bit(0, true)
	$TileMap.set_collision_layer_bit(1, false)
	$TileMap.set_collision_mask_bit(0, true)
	$TileMap.set_collision_mask_bit(1, false)
	set_collision_layer_bit(0, true)
	set_collision_layer_bit(1, false)
	
	for door in $Doors.get_children():
		door.set_collision_layer_bit(0, true)
		door.set_collision_layer_bit(1, false)
		door.set_collision_mask_bit(0, true)
		door.set_collision_mask_bit(1, false)
		door.visible = true
	
	visible = true
	
func remove_enemies():
	for mob in $Mobs.get_children():
		mob.queue_free()
