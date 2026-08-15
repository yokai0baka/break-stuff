extends Node2D

func _ready() -> void:
	Global.return_values()
	MenuMusic.play()

func _on_play_pressed() -> void:
	$AudioStreamPlayer2D.play()
	$Options.disabled = true
	$Exit.disabled = true
	await get_tree().create_timer(0.5).timeout
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/menu/SelectStage.tscn")

func _on_options_pressed() -> void:
	$AudioStreamPlayer2D.play()
	$Play.disabled = false
	$Exit.disabled = false
	await get_tree().create_timer(0.5).timeout
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/menu/MenuOptions.tscn")

func _on_exit_pressed() -> void:
	$AudioStreamPlayer2D.play()
	$Play.disabled = false
	$Options.disabled = false
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
