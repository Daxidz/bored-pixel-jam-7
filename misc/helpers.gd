# Node which is AutoLoaded to provide helpers functions

extends Node


func randi_limited(_min: int, _max: int):
	#assert(_max > _min)
	return _min + randi() % (_max - _min)