extends Node

# Score vars
var score = 0
var time = 60.0
var time_spd = 1
var bomber_time = 0
var energy = 0

# Get info displayed on screen
var get_info_positive = false
var get_info_negative = false
var player_attacked = false

# Conditionals vars
var game_paused = false
var end_game = false
var selected_stage = "City"
var bomber_drop = false

# VFX effects options
var crt_displayed = true
var gameboy_displayed = true
var neutral_displayed = false

func _process(delta: float) -> void:
	if game_paused:
		time -= 0
		bomber_time -= 0
	else:
		time -= delta
		bomber_time += delta

	if time <= 0:
		end_game = true
		time = 0
	
	if bomber_time >= 15.0:
		bomber_drop = true
		bomber_time = 0

func return_values():
	Global.time = 60.0
	Global.score = 0
	Global.game_paused = false
	Global.end_game = false
	Global.bomber_time = 0
