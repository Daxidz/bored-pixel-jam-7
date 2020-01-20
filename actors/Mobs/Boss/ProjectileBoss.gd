extends KinematicBody2D

var direction

var dmg
var speed = 200
var velocity = Vector2()
var projectile_damage = 1

var bounce = false
var bounces_count = 0

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
		if collision.collider.name == "TileMap":
			if bounce and  bounces_count >= 2:
				velocity = velocity.bounce(collision.normal)
				bounces_count += 1
			else:
				queue_free()
			
		if collision.collider.has_method("take_damage"):
			collision.collider.take_damage(projectile_damage)
			self.queue_free()

func shoot(start_pos, end_pos):
	self.global_position = start_pos
	direction = (end_pos - start_pos).normalized()
