extends Area2D

onready var helpers = get_node("/root/helpers")
var Mob = preload("res://Mob.tscn")

export var size_tiles: Vector2 = Vector2.ZERO


export var show_border: bool = false

const MAP_SIZE = 50

var id: int = -1

var neighbors = []

var drawn = false

var pos_on_minimap

func _init():
    self.neighbors.resize(4)

#func _ready():
#    var rect_shape = RectangleShape2D.new()
#    rect_shape.extents = size
#    $Collision.shape = rect_shape

	
# Add mobs to the Room
# types is an array of types
func add_mob(type, position):
	var mob = Mob.instance()
	var mob_pos = position
	add_child(mob)

func set_size(size):
    self.size_tiles = size
