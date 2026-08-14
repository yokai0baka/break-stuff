extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.gameboy_displayed:
		$NeutralFilterLabel/NeutralButton.modulate = "#939393"

func _on_return_button_pressed() -> void:
	$AudioStreamPlayer2D.play()
	$ReturnButton.disabled = false
	await get_tree().create_timer(0.5).timeout
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/menu/MainMenu.tscn")

func _on_crt_button_pressed() -> void:
	if Global.crt_displayed:
		$CRTLabel/CRTButton.modulate = "#939393"
		Global.crt_displayed = false
	elif !Global.crt_displayed:
		$CRTLabel/CRTButton.modulate = "#ffffff"
		Global.crt_displayed = true

func _on_gam_boy_button_pressed() -> void:
	if Global.gameboy_displayed:
		$GameBoyFilterLabel/GamBoyButton.modulate = "#939393"
		$NeutralFilterLabel/NeutralButton.modulate = "#ffffff"
		Global.gameboy_displayed = false
		Global.neutral_displayed = true
	elif !Global.gameboy_displayed:
		$GameBoyFilterLabel/GamBoyButton.modulate = "#ffffff"
		$NeutralFilterLabel/NeutralButton.modulate = "#939393"
		Global.gameboy_displayed = true
		Global.neutral_displayed = false

func _on_neutral_button_pressed() -> void:
	if Global.neutral_displayed:
		$NeutralFilterLabel/NeutralButton.modulate = "#939393"
		$GameBoyFilterLabel/GamBoyButton.modulate = "#ffffff"
		Global.neutral_displayed = false
		Global.gameboy_displayed = true
	elif !Global.neutral_displayed:
		$NeutralFilterLabel/NeutralButton.modulate = "#ffffff"
		$GameBoyFilterLabel/GamBoyButton.modulate = "#939393"
		Global.neutral_displayed = true
		Global.gameboy_displayed = false
