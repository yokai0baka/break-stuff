extends Node2D


func _on_city_button_pressed() -> void:
	set_to_game()
	Global.selected_stage = "City"
	$DesertButton.disabled = true
	$OceanButton.disabled = true
	$MoonButton.disabled = true
	await get_tree().create_timer(1.5).timeout
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/stages/City.tscn")


func _on_desert_button_pressed() -> void:
	set_to_game()
	Global.selected_stage = "Desert"
	$CityButton.disabled = true
	$OceanButton.disabled = true
	$MoonButton.disabled = true
	await get_tree().create_timer(1.5).timeout
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/stages/Desert.tscn")


func _on_ocean_button_pressed() -> void:
	set_to_game()
	Global.selected_stage = "Ocean"
	$CityButton.disabled = true
	$DesertButton.disabled = true
	$MoonButton.disabled = true
	await get_tree().create_timer(1.5).timeout
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/stages/Ocean.tscn")


func _on_moon_button_pressed() -> void:
	set_to_game()
	Global.selected_stage = "Moon"
	$CityButton.disabled = true
	$DesertButton.disabled = true
	$OceanButton.disabled = true
	await get_tree().create_timer(1.5).timeout
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/stages/Moon.tscn")

func set_to_game():
	$TransitionScreen.play("fade_in")
	MenuMusic.stop()
	$AudioStreamPlayer2D.play()
