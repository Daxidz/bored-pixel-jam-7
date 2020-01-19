extends KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	show()

export var run_speed = 300
const DEFAULT_MASS = 2.0
var velocity = Vector2.ZERO
var player = null

func _physics_process(delta):
	
	velocity = Vector2.ZERO
	var desired_velocity = Vector2.ZERO
	var steering = Vector2.ZERO
	var mouse_pos = get_global_mouse_position()
	

	if player:
		desired_velocity = (player.position - position).normalized() * run_speed
		steering = (desired_velocity - velocity) / DEFAULT_MASS
		#print(velocity)
		velocity = velocity + steering
		velocity = move_and_slide(velocity)
		if get_slide_count() != 0:
			var collision = get_slide_collision(0)
			if collision.collider.name == "Player":
				collision.collider.take_damage(1)
		#position = position.linear_interpolate(player.position, delta * run_speed)

func _on_DetectRadius_body_entered(body):
	if body.get_name() == "Player":
    	player = body
		
func _on_DetectRadius_body_exited(body):
	if body.get_name() == "Player":
    	player = null

