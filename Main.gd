extends Node

var Player = preload("res://actors/player/Player.tscn") 

const MAX_ROOMS = 10
const MIN_ROOMS = 5

var current_room_index = 0
var current_room 

var player

# debug purpose
# 0  
enum Camera {PLAYER, MAP}

var current_cam = Camera.MAP

func init_dungeon():
	$DungeonGenerator.destroy_dungeon()
	$DungeonGenerator.init()
	$DungeonGenerator.create_dungeon(MIN_ROOMS + (randi() % (MAX_ROOMS - MIN_ROOMS)))
#	$DungeonGenerator.create_dungeon(1)
	
	player = Player.instance()
	
#	player.position = $DungeonGenerator/Rooms.get_child(0).size_tiles * 32 / 2
	player.position = Vector2(-10, -10)
	$DungeonGenerator/Rooms.get_child(0).add_child(player)

func _ready():
	randomize()
	init_dungeon()
	current_room = $DungeonGenerator.rooms[0]
	
	
	
	#add_child(current_room)
	
func _input(event):
	if Input.is_action_just_pressed("ui_select"):
		player.free()
		init_dungeon()
	if Input.is_action_just_pressed("switch_camera"):
		switch_camera()
#	if Input.is_action_just_pressed("next_room"):
#		change_room()

func switch_camera():
	
	current_cam = (current_cam + 1) % Camera.size()
	player.set_camera(current_cam == Camera.PLAYER)
	$Camera2D.current = current_cam == Camera.MAP
	
		
func change_room():
	
	if current_room:
		current_room.free()
	var nb_rooms = $DungeonGenerator.rooms.size()
	var current_room = $DungeonGenerator.rooms[current_room_index]
	current_room_index = current_room_index % nb_rooms
	
	add_child(current_room)

