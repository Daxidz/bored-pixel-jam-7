extends KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Main/GameManager/Player")

export var run_speed = 150
const DEFAULT_MASS = 2.0
var velocity = Vector2.ZERO
var player = null

func _physics_process(delta):
	
	velocity = Vector2.ZERO
	var desired_velocity = Vector2.ZERO
	var steering = Vector2.ZERO
	
	if player:
		desired_velocity = (player.position - position).normalized() * run_speed
		steering = (desired_velocity - velocity) / DEFAULT_MASS
		velocity = velocity + steering
		velocity = move_and_slide(velocity)
		if get_slide_count() != 0:
			var collision = get_slide_collision(0)
			if collision.collider.name == "Player":
				collision.collider.take_damage(2)
				
				
func _process(delta):
	
	var a = velocity.angle()
	var animation = ""
		
	var flip_x = false

	
	if (a > PI / 4) and (a < (PI * 3/4)):
		animation = "walk_front"
#	elif (a > ((PI * 5) / 4)) and (a < PI * 7 / 4):
	elif (a < -PI / 4) and (a > (-PI * 3/4)):
		animation = "walk_back"
	else:
		
		animation = "walk_side"
		if velocity.x < 0:
			flip_x = true
		else:
			flip_x = false
		
	$Sprite.flip_h = flip_x
	
	if animation != $AnimationPlayer.current_animation and animation != "":
		$AnimationPlayer.play(animation)
	pass