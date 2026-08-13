extends CharacterBody3D

var SPEED = 2.0
var actual_special = 1

# Attack colliders directions
@onready var collision_shape_l: CollisionShape3D = $"Attacks/Attack-L/CollisionShapeL"
@onready var collision_shape_r: CollisionShape3D = $"Attacks/Attack-R/CollisionShapeR"

# Animations
@onready var animation_player: AnimationPlayer = $SubViewport/Player2dModel/AnimationPlayer
@onready var animation_attack: AnimationPlayer = $SubViewport/Player2dModel/AnimationAttack
@onready var animation_juice: AnimationPlayer = $AnimationJuice
@onready var animation_hud: AnimationPlayer = $SpringArm3D/Camera3D/HUD/AnimationHUD
@onready var animation_flashing: AnimationPlayer = $SpringArm3D/Camera3D/HUD/AnimationFlashing

var current_scene = "res://scenes/stages/" + str(Global.selected_stage) + ".tscn"

func _process(_delta: float) -> void:
	$SpringArm3D/Camera3D/HUD/Score.text = "Score: " + str(Global.score)
	$SpringArm3D/Camera3D/HUD/Time.text = str(roundi(Global.time))
	
	if collision_shape_r.disabled == false || collision_shape_l.disabled == false:
		animation_attack.play("Attack")
	
	# Flip attack direction
	if $Sprite3D.flip_h == true:
		if Input.is_action_just_pressed("attack") && collision_shape_r.disabled:
			collision_shape_r.disabled = false
			$SpringArm3D/AnimationCamera.play("attack_zoom")
			await get_tree().create_timer(0.75).timeout
			collision_shape_r.disabled = true
	elif $Sprite3D.flip_h == false:
		if Input.is_action_just_pressed("attack") && collision_shape_l.disabled:
			collision_shape_l.disabled = false
			$SpringArm3D/AnimationCamera.play("attack_zoom")
			await get_tree().create_timer(0.75).timeout
			collision_shape_l.disabled = true
	
	if Input.is_action_just_pressed("change_special"):
		actual_special += 1
		$SpringArm3D/Camera3D/HUD/SpecialSelector.frame += 1
		if actual_special == 4 || $SpringArm3D/Camera3D/HUD/SpecialSelector.frame == 3:
			$SpringArm3D/Camera3D/HUD/SpecialSelector.frame = 0
			actual_special = 1
	
	if Input.is_action_just_pressed("special"):
		match actual_special:
			1:
				if Global.energy >= 6:
					if $Sprite3D.flip_h == false:
						$Attacks/AnimationSpecial.play("special1_L")
						await get_tree().create_timer(2.0).timeout
						Global.energy = 0
					elif $Sprite3D.flip_h == true:
						$Attacks/AnimationSpecial.play("special1_R")
						await get_tree().create_timer(2.0).timeout
						Global.energy = 0
			2:
				if Global.energy >= 6:
					$Attacks/AnimationSpecial.play("special2")
					await get_tree().create_timer(2.0).timeout
					Global.energy = 0
			3:
				if Global.energy >= 6:
					$Attacks/AnimationSpecial.play("special3")
					await get_tree().create_timer(2.0).timeout
					Global.energy = 0
	
	if Global.energy <= 2:
		$SpringArm3D/Camera3D/HUD/Geiger.play("geiger_low")
	elif Global.energy <= 4:
		$SpringArm3D/Camera3D/HUD/Geiger.play("geiger_mid")
	else:
		$SpringArm3D/Camera3D/HUD/Geiger.play("geiger_high")
	
	# Game pause
	if Input.is_action_just_pressed("menu") && !Global.game_paused:
		animation_hud.play("paused")
		animation_flashing.play("flashing_paused")
		Global.game_paused = true
	elif Input.is_action_just_pressed("menu") && Global.game_paused:
		animation_hud.play_backwards("paused")
		animation_flashing.play("RESET")
		Global.game_paused = false
	
	if Global.game_paused:
		SPEED = 0.0
	else:
		SPEED = 2.0
	
	if Global.player_attacked:
		$SpringArm3D/Camera3D.screen_shake(1.0, 0.5)
		await get_tree().create_timer(0.5).timeout
		Global.player_attacked = false
	
	if !Global.get_info_positive:
		$SpringArm3D/Camera3D/HUD/PlusScore.visible = false
		$SpringArm3D/Camera3D/HUD/PlusTime.visible = false
	else:
		$SpringArm3D/Camera3D/HUD/PlusScore.visible = true
		$SpringArm3D/Camera3D/HUD/PlusTime.visible = true
	
	if !Global.get_info_negative:
		$SpringArm3D/Camera3D/HUD/MinusTime.visible = false
	else:
		$SpringArm3D/Camera3D/HUD/MinusTime.visible = true
	
	# Trigger end game
	if Global.end_game:
		await get_tree().process_frame
		get_tree().change_scene_to_file("res://scenes/menu/MainMenu.tscn")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		animation_juice.play("Movement")
		animation_player.play("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		animation_juice.play("Idle")
		animation_player.play("Idle")

	# Flip sprite
	if direction.x > 0:
		$Sprite3D.flip_h = true
	elif direction.x < 0:
		$Sprite3D.flip_h = false

	move_and_slide()

func stop_showing_info():
	Global.get_info_positive = false
	Global.get_info_negative = false

func _on_menu_button_pressed() -> void:
	Global.return_values()
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/menu/MainMenu.tscn")

func _on_restart_button_pressed() -> void:
	Global.return_values()
	await get_tree().process_frame
	get_tree().change_scene_to_file(current_scene)
