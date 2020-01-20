extends Node

var Player = preload("res://actors/player/Player.tscn")

onready var global = get_node("/root/global")

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
	$HUD/GAMEOVER.visible = false
	$HUD/RestartButton.visible = false
	init_dungeon()
	current_room = null
	if is_instance_valid(player):
		if player:
			player.free()
	
	player = Player.instance()
	player.connect("drug_taken", self, "room_cleared")
	player.connect("player_hp_change", self, "update_hp")
	
	update_hp(player.hp)
	
	add_child(player)
	
	# We do this there so the first room doesn't spawn mobs
	current_room = $DungeonGenerator.get_room(0)
	current_room.enable()
	current_room.visited = true
	$DungeonGenerator.add_drug_to_room(current_room)
	
	player.position = current_room.size_tiles * 32 / 2
	
	var maintheme = randi() % 2 + 1
#	var stream = load("res://music/maintheme" + str(maintheme) +".ogg")
	var stream = load("res://music/maintheme1.ogg")
	$AudioStreamPlayer.stream = stream
	$AudioStreamPlayer.play()
	
	
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
	
	
func on_door_entered(door):
	
	if not current_room.cleared:
			return
			
	var new_player_pos = Vector2.ZERO
	change_room(door.id_neighboor)
	
	match door.orientation:
		global.Orientations.NORTH:
			new_player_pos.x = current_room.size_tiles.x / 2
			new_player_pos.y = current_room.size_tiles.y - 1.7
		global.Orientations.SOUTH:
			new_player_pos.x = current_room.size_tiles.x / 2
			new_player_pos.y = 2.5
		global.Orientations.EAST:
			new_player_pos.x = 1.7
			new_player_pos.y = current_room.size_tiles.y / 2
		global.Orientations.WEST:
			new_player_pos.x = current_room.size_tiles.x - 1.7
			new_player_pos.y = current_room.size_tiles.y / 2
			
	player.position = new_player_pos * 32

# Callback called when the player takes the drug in the current room
func room_cleared():
	current_room.cleared = true
	current_room.remove_enemies()
	
func update_hp(new_hp):
	$HUD/HPs.update_hp(new_hp)
	
	if new_hp == 0:
		game_over()

func game_over():
	$HUD/GAMEOVER.visible = true
	$HUD/RestartButton.visible = true
	player.die()

func _on_RestartButton_pressed():
	start_game()
