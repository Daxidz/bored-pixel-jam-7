extends KinematicBody2D

var player = null
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Main/GameManager/Player")

var bandage = preload("res://actors/Mobs/Nurse/Projectile.tscn")

func shotProjectile(target):
	var proj = bandage.instance()
	get_parent().add_child(proj)
	proj.shoot(self.position, target)
	print((target - self.position).normalized().angle())

func _on_Timer_timeout():
	var animation
	
	if player:
		shotProjectile(player.position)
		animation = 'attack_front'
		animate(animation)

func animate(animation):
	$AnimationPlayer.play(animation)