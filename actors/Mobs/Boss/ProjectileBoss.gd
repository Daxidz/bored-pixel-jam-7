extends KinematicBody2D

const PROJECTILE_SPEED = 200
var direction

var dmg
var speed = 200
var velocity = Vector2()
var projectile_damage = 1

func start(pos, dir):
	rotation = dir
	position = pos
	velocity = Vector2(speed, 0).rotated(rotation)

func set_dmg(dmg):
	self.dmg = dmg

func _ready():
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.

#func _physics_process(delta):
#	position = position + direction * PROJECTILE_SPEED * delta
func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider_shape == null:
			self.queue_free()
		else:
			velocity = velocity.bounce(collision.normal)
			if collision.collider.has_method("take_damage"):
				collision.collider.take_damage(projectile_damage)
				self.queue_free()

func shoot(start_pos, end_pos):
	self.global_position = start_pos
	direction = (end_pos - start_pos).normalized()

func _on_Bandage_body_entered(body):
	if body.get_name() == "Player":
		body.take_damage(dmg)
		queue_free()
		
	if body.get_name() == "TileMap":
		queue_free()
