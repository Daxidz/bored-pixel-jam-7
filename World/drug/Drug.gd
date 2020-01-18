extends Area2D

const EFFECTS_DIR = "res://World/drug/effects/"

#const EFFECTS = ["speed_up", "hp_to_1", "invisible", "vision_reduced", "speed_down"]
const EFFECTS = ["size_down", "size_up"]

var effects = []

func _ready():
	var effect_path = EFFECTS_DIR + EFFECTS[randi()%EFFECTS.size()] + ".gd"
	var effect = load(effect_path).new()
	effects.push_back(effect)
	
func _on_Drug_body_entered(body):
	if body.name == "Player":
		print("Player taking the drug ", self)
		body.take_drug(self)
		_disable()
#		self.queue_free()


func _disable():
	visible = false
	set_collision_layer_bit(0, false)
	set_collision_layer_bit(1, true)
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(1, true)
	

func apply_effects(player):
	print(effects)
	for effect in effects:
		effect.apply_on_player(player)
		

func remove_effects(player):
	print(effects)
	for effect in effects:
		effect.remove_from_player(player)
	