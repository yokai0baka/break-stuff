extends Node2D


func _on_city_button_pressed() -> void:
	Global.selected_stage = "City"
	$AudioStreamPlayer2D.play()
	$DesertButton.disabled = true
	$OceanButton.disabled = true
	$MoonButton.disabled = true
	await get_tree().create_timer(0.5).timeout
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/stages/City.tscn")
