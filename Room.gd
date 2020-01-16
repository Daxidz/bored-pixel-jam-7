extends RigidBody2D

var size: Vector2 = Vector2.ZERO

export var show_border: bool = false

const MAP_SIZE = 50

var id: int = -1

var neighbors = []

var drawn = false

var pos_on_minimap

func _init():
    self.neighbors.resize(4)

func _ready():
    var rect_shape = RectangleShape2D.new()
    rect_shape.extents = size
    $Collision.shape = rect_shape

func _draw():
    draw_border(show_border)

func draw_border(show):
    # position - size to get the 0 relative to the current room
    var border = Rect2(self.position - self.size, self.size*2)
    var label = Label.new()
    var font = label.get_font("")
    if show && drawn == false:
        draw_rect(border, Color(64, 0, 64), false)
        draw_char(font, self.pos_on_minimap, "1", "", Color(64, 0, 64))
        drawn = true
    label.free()

func set_size(size):
    self.size = size