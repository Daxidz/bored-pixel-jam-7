extends Node


func _ready():
	$StartAnimation.visible = false
	$Menu/AudioStreamPlayer.play()

func _on_StartBtn_pressed():
	$Menu/AudioStreamPlayer.stop()
	$Menu.free()
	$StartAnimation.visible = true
	$StartAnimation.play("start_anim")
	
	pass # Replace with function body.

func _on_CreditsBtn_pressed():
	pass # Replace with function body.


func _on_ExitBtn_pressed():
	get_tree().quit()
	pass # Replace with function body.

func _on_StartAnimation_animation_finished():
	$StartAnimation.stop()
	$StartAnimation.visible = false
	$GameManager.start_game()
	pass # Replace with function body.
