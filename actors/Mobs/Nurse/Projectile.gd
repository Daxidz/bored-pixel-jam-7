extends Area2D

const PROJECTILE_SPEED = 200
var direction

func _ready():
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta):
	position = position + direction * PROJECTILE_SPEED * delta


func shoot(start_pos, end_pos):
	self.global_position = start_pos
	direction = (end_pos - start_pos).normalized()



func _on_Bandage_body_entered(body):
	if body.get_name() == "Player":
		queue_free()
