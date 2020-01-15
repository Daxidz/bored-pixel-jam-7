extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	make_current()
	set_process_input(true)
	pass # Replace with function body.

func _input(event):
	if (Input.is_action_pressed("ui_zoom_up")):
		self.zoom.x /= 2
		self.zoom.y /= 2
	elif (Input.is_action_pressed("ui_zoom_down")):
		self.zoom.x *= 2
		self.zoom.y *= 2
	elif (Input.is_action_pressed("ui_up")):
		set_offset(Vector2(get_offset().x, get_offset().y + 10))
	elif (Input.is_action_pressed("ui_down")):
		set_offset(Vector2(get_offset().x, get_offset().y - 10))
	elif (Input.is_action_pressed("ui_left")):
		set_offset(Vector2(get_offset().x + 10, get_offset().y))
	elif (Input.is_action_pressed("ui_right")):
		set_offset(Vector2(get_offset().x - 10, get_offset().y))