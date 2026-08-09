extends CharacterBody3D

const SPEED = 2.0
const JUMP_VELOCITY = 4.5

# Attack colliders directions
@onready var collision_shape_l: CollisionShape3D = $"Attack-L/CollisionShapeL"
@onready var collision_shape_r: CollisionShape3D = $"Attack-R/CollisionShapeR"

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
			await get_tree().create_timer(1.0).timeout
			collision_shape_r.disabled = true
	elif $Sprite3D.flip_h == false:
		if Input.is_action_just_pressed("attack") && collision_shape_l.disabled:
			collision_shape_l.disabled = false
			$SpringArm3D/AnimationCamera.play("attack_zoom")
			await get_tree().create_timer(1.0).timeout
			collision_shape_l.disabled = true
	
	# Game pause
	if Input.is_action_just_pressed("menu") && !Global.game_paused:
		animation_hud.play("paused")
		animation_flashing.play("flashing_paused")
		await get_tree().create_timer(1.0).timeout
		Global.game_paused = true
	elif Input.is_action_just_pressed("menu") && Global.game_paused:
		animation_hud.play_backwards("paused")
		animation_flashing.play("RESET")
		await get_tree().create_timer(1.0).timeout
		Global.game_paused = false
	
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
		get_tree().change_scene_to_file("res://scenes/menu/Menu.tscn")

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
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/menu/MainMenu.tscn")

func _on_restart_button_pressed() -> void:
	await get_tree().process_frame
	get_tree().change_scene_to_file(current_scene)
