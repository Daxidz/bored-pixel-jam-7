extends Area2D

var Attack1 = preload("res://actors/Mobs/Boss/Attacks/Attack1.tscn")
var Attack2 = preload("res://actors/Mobs/Boss/Attacks/Attack2.tscn")


var current_phase = 0

var attacking = false

var room

var speed = 400

#onready var player = get_node("/root/Main/GameManager/Player")


func _ready():
	$AnimationPlayer.play("phase1")
	$ProjectileTimer.start()
	$PhasesTimer.start()
	
	var attack = Attack2.instance()
	attack.place(position)
	attack.connect("over", self, "_on_attack_over")
	add_child(attack)
	attacking = true
	
func set_room(room):
	self.room = room
	

func _physics_process(delta):
	
	pass

func wander():
	
	pass

func _on_ProjectileTimer_timeout():
	return
#	if attacking:
#		return
	var attack
		
	match current_phase:
		1:
			attack = Attack2.instance()
			attack.place(position)
			attack.connect("over", self, "_on_attack_over")
			add_child(attack)
			attacking = true



func _on_attack_over():
	attacking = false

func _on_PhasesTimer_timeout():
	current_phase += 1
