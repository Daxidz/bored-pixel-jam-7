extends RigidBody2D

var size: Vector2 = Vector2.ZERO

export var show_border: bool = false

const MAP_SIZE = 50

var up_neigh
var down_neigh
var right_neigh
var left_neigh

var neighbors = [4]

var drawn = false

var pos_on_minimap



func _ready():
	var rect_shape = RectangleShape2D.new()
	rect_shape.extents = size
	$Collision.shape = rect_shape

	

func _draw():
	draw_border(show_border)
	
func draw_border(show):
	# position - size to get the 0 relative to the current room
	var border = Rect2(self.position - self.size, self.size*2)
	if show:
		draw_rect(border, Color(64, 0, 64), false)


func set_size(size):
	self.size = size