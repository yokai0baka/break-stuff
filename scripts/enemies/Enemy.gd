extends CharacterBody3D

var SPEED = 0.75

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var attack_sound: AudioStreamPlayer3D = $AttackSound
@onready var death_sound: AudioStreamPlayer3D = $DeathSound
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_shooting: AnimationPlayer = $SubViewportShoot/Shooting2DModel/AnimationShooting

var cooldown_attack = 0.0

func _process(delta: float) -> void:
	if cooldown_attack <= 5.0:
		cooldown_attack -= delta
	
	if Global.game_paused:
		SPEED = 0.0
	else:
		SPEED = 0.75

func _physics_process(delta: float) -> void:
	var current_location = global_transform.origin
	var next_location = navigation_agent_3d.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	velocity = velocity.move_toward(new_velocity, .25)
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if next_location.x > 0:
		$Sprite3D.flip_h = false
		$Sprite3DAttack.flip_h = false
	elif next_location.x < 0:
		$Sprite3D.flip_h = true
		$Sprite3DAttack.flip_h = true
	
	move_and_slide()

func update_target_location(target_location):
	navigation_agent_3d.target_position = target_location

func _on_navigation_agent_3d_target_reached() -> void:
	if cooldown_attack <= 0.0:
		self.attack()

func attack():
	Global.player_attacked = true
	Global.get_info_negative = true
	Global.time -= 10
	self.attack_sound.play()
	self.cooldown_attack = 5.0
	self.animation_shooting.play("shooting")

func _on_hitzone_area_entered(area: Area3D) -> void:
	if "Attack" in area.name:
		get_killed()
	
	if "Special" in area.name:
		get_killed()

func get_killed():
	$Sprite3D.visible = false
	$CollisionShape3D.disabled = true
	Global.score += 50
	Global.time += 5.0
	Global.get_info_positive = true
	self.death_sound.play()
	self.animation_player.play("death")
	await get_tree().create_timer(1.75).timeout
