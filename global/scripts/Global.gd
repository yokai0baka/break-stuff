extends Node

var score = 0
var time = 60
var time_spd = 1

var get_info_positive = false
var get_info_negative = false
var player_attacked = false

var game_paused = false
var end_game = false
var selected_stage = "City"

func _process(delta: float) -> void:
	if game_paused:
		time -= 0
	else:
		time -= delta

	if time <= 0:
		end_game = true
		time = 0
