extends RigidBody3D
class_name Building

var health = 2

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var hitzone: Area3D = $Hitzone

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if health <= 0:
		self.hitzone.collision_layer = 0
		self.collision_shape_3d.disabled = true
		self.animation_player.play("collapsed")
		await get_tree().create_timer(2.0).timeout
		self.animation_player.pause()

func _on_hitzone_area_entered(area: Area3D) -> void:
	if "Attack" in area.name:
		Global.score += 100
		Global.time += 5.0
		Global.get_info = true
		self.health -= 1
		self.animation_player.play("damage")
