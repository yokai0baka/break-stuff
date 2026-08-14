extends Node3D

@onready var tank = preload("res://scenes/enemies/Tank.tscn")
@onready var heli = preload("res://scenes/enemies/Helicopter.tscn")

@onready var spawner: Node3D = $"."

func _on_timer_timeout() -> void:
	spawn(spawner.global_position)

func spawn(pos):
	var enemy_tank = tank.instantiate() as Node3D
	var enemy_heli = heli.instantiate() as Node3D
	
	if enemy_tank:
		enemy_tank.position = pos
	
	if enemy_heli:
		enemy_heli.position = pos
	
	add_child(enemy_tank)
	add_child(enemy_heli)
