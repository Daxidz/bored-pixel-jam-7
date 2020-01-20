extends Node

signal over


var Projectile = preload("res://actors/Mobs/Boss/ProjectileBoss.tscn")
onready var global = get_node("/root/global")

# each 10°
const ANGLE_DELTA = PI/2

var attacking


func place(position):
	$Position2D.position = position


func _ready():
	for i in 4:
		
		update_angle()
		var angle = $Position2D.rotation
		var direction = Vector2(cos(angle), sin(angle)).normalized()
		shoot(direction)
		
	
	emit_signal("over")
	queue_free()
	
	
func update_angle():
	$Position2D.rotation += PI/2


func shoot(direction):
	var projectile = Projectile.instance()
	projectile.set_dmg(1)
	projectile.speed = 300
	projectile.start($Position2D.position / global.TILE_SIZE, $Position2D.rotation)
	get_parent().add_child(projectile)
	#projectile.shoot($Position2D.direction, direction + $Position2D.position)



func attack_phase2():
	pass
func _on_Timer_timeout():
	
	
	pass # Replace with function body.
