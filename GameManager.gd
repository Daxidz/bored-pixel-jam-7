extends Node

var Player = preload("res://actors/player/Player.tscn") 

const MAX_ROOMS = 6
const MIN_ROOMS = 10

var current_room_index = 0
var current_room 

var player

# debug purpose
# 0  
enum Camera {PLAYER, MAP}

var current_cam = Camera.PLAYER

func init_dungeon():
	$DungeonGenerator.destroy_dungeon()
	$DungeonGenerator.init()
	$DungeonGenerator.create_dungeon(MIN_ROOMS + (randi() % (MAX_ROOMS - MIN_ROOMS)))


func start_game():
	randomize()
	init_dungeon()
	current_room = null
	player = Player.instance()
	player.connect("drug_taken", self, "room_cleared")
	change_room(0)
	add_child(player)
	
	
func _input(event):
	if Input.is_action_just_pressed("ui_select"):
		player.free()
		start_game()
	if Input.is_action_just_pressed("switch_camera"):
		switch_camera()


func switch_camera():
	current_cam = (current_cam + 1) % Camera.size()
	player.set_camera(current_cam == Camera.PLAYER)
	$Camera2D.current = current_cam == Camera.MAP
	
	
func room_cleared():
	current_room.cleared = true
	current_room.remove_enemies()
	pass


func change_room(new_room_id):
	var new_room
	
	if current_room:
		if not current_room.cleared:
			return
		current_room.disable()
		
	new_room = $DungeonGenerator.get_room(new_room_id)
	new_room.enable()

	if not new_room.visited:
		print("New room visited! ", new_room)
		$DungeonGenerator.populate_room(new_room)
#		$DungeonGenerator.add_room_to_map(new_room)
		$DungeonGenerator.add_drug_to_room(new_room)
		new_room.visited = true
	
	current_room = new_room
	player.position = current_room.size_tiles * 32 / 2
