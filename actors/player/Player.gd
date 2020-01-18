extends KinematicBody2D

signal use

signal drug_taken

export var BASE_FRICTION = 0.2
var STOP_FRICTION = 0.5

export var curent_anim = "idle"
export var max_speed = 400

var friction
var acceleration

const BASE_ACCEL = 0.4
const BASE_SPEED = 350

var screen_size


var velocity = Vector2.ZERO
var input_velocity = Vector2.ZERO

var interacting_objects: Array

enum STATES { IDLE, MOVING, TOUCHED } 

var state = "idle"

var taking_drug = false

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


	input_velocity = input_velocity * max_speed
	
	if input_velocity.length() > 0:
		velocity = velocity.linear_interpolate(input_velocity, acceleration)
	else:
		#friction = STOP_FRICTION
		if velocity.length() != 0:
			velocity = velocity.linear_interpolate(Vector2.ZERO, friction)

	if not taking_drug:
		velocity = move_and_slide(velocity)


func set_camera(is_current):
	$Camera2D.current = is_current
	
func _process(delta):
	var animation
	if input_velocity.x != 0:
		animation = "side_move"
		# Update Sprite orientation when side running
		if input_velocity.x < 0:
			$Sprite.scale.x = -1
		else:
			$Sprite.scale.x = 1
			
	elif input_velocity.y != 0:
		if input_velocity.y < 0:
			animation = "back_move"
		else:
			animation = "front_move"
	else:
		animation = "idle"
	pass
	
	
	if taking_drug:
		animation = "take_drug"
		
	if not ($AnimationPlayer.current_animation == animation):
		animate(animation)
		
func animate(animation):
	$AnimationPlayer.play(animation)
	
func take_drug(drug):
	taking_drug = true
	emit_signal("drug_taken")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "take_drug":
		taking_drug = false
	pass # Replace with function body.
