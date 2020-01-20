extends Node

signal over


var Projectile = preload("res://actors/Mobs/Boss/ProjectileBoss.tscn")

# each 10°
const ANGLE_DELTA = 15

var attacking


func place(position):
	$Position2D.position = position

func _ready():
	$Timer.start()
	
	
func update_angle():
	$Position2D.rotation_degrees += ANGLE_DELTA
	if $Position2D.rotation_degrees > 360:
		queue_free()
		emit_signal("over")


func shoot(target):
	
	var projectile = Projectile.instance()
	projectile.set_dmg(1)
	get_parent().add_child(projectile)
	projectile.shoot($Position2D.position, target + $Position2D.position)


func _on_Timer_timeout():
	update_angle()
	
	var angle = $Position2D.rotation
	
	var direction = Vector2(cos(angle), sin(angle)).normalized()
	
	print("shooting at angle ", direction)  
	shoot(direction)
	pass # Replace with function body.
