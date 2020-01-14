extends KinematicBody2D

signal use

export var BASE_FRICTION = 0.2
var STOP_FRICTION = 0.5

export var curent_anim = "idle"
export var max_speed = 400

export var friction = 0.2
export var friction_delta = 0.0002
export var acceleration = 0.1

const BASE_ACCEL = 0.4
const DASH_ACCEL = 0.4

const BASE_SPEED = 700
const DASH_SPEED = 1000


var end_dashing = false

var screen_size

var attacking = false
var end_attack = false
var dashing = false

var velocity = Vector2.ZERO
var input_velocity = Vector2.ZERO

var interacting_objects: Array

enum STATES { IDLE, MOVING, TOUCHED } 

var state = "idle"

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
	 
func _physics_process(delta):
	
	max_speed = BASE_SPEED
	acceleration = BASE_ACCEL
	friction = BASE_FRICTION

	input_velocity = Vector2.ZERO
	input_velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if abs(input_velocity.x) == 1 and abs(input_velocity.y) == 1:
		input_velocity = input_velocity.normalized()


	velocity = input_velocity * max_speed
	
	if input_velocity.length() > 0:
		velocity = velocity.linear_interpolate(input_velocity, acceleration)
	else:
		#friction = STOP_FRICTION
		if velocity.length() != 0:
			velocity = velocity.linear_interpolate(Vector2.ZERO, friction)

	if attacking:
		velocity = velocity * 0.3
		
	velocity = move_and_slide(velocity)
	
func _process(delta):
	pass