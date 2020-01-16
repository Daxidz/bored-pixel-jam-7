extends Node

const MAX_ROOMS = 30
const MIN_ROOMS = 10

func init_dungeon():
    $DungeonGenerator.destroy_dungeon()
    $DungeonGenerator.init()
    $DungeonGenerator.create_dungeon(MIN_ROOMS + (randi() % (MAX_ROOMS - MIN_ROOMS)))

func _ready():
    randomize()
    init_dungeon()

func _input(event):
    if Input.is_action_just_pressed("ui_select"):
        init_dungeon()