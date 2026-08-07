extends Node

var score = 0
var time = 10
var time_spd = 1
var get_info = false

var game_paused = false
var end_game = false

func _process(delta: float) -> void:
	if game_paused:
		time -= 0
	else:
		time -= delta

	if time <= 0:
		end_game = true
		time = 0
