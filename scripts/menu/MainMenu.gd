extends Node2D

func _on_play_pressed() -> void:
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/stages/City.tscn")

func _on_options_pressed() -> void:
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/menu/MenuOptions.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
