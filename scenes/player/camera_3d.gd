extends Camera3D

# Shake constants
const DEFAULT_SHAKE_DECAY: float = 5.0
const DEFAULT_SHAKE_TIME_SPEED: float = 20.0
const DEFAULT_NOISE_FREQUENCY: float = 2.0
const RETURN_TO_CENTER_SPEED: float = 10.5

# Shake variables
var shake_intensity: float = 0.0
var active_shake_time: float = 0.0
var shake_decay: float = DEFAULT_SHAKE_DECAY
var shake_time: float = 0.0
var shake_time_speed: float = 0.0

var noise = FastNoiseLite.new()


func _physics_process(delta: float) -> void:
	if active_shake_time > 0:
		shake_time += delta * shake_time_speed
		active_shake_time -= delta
		
		h_offset = noise.get_noise_2d(shake_time, 0) * shake_intensity
		v_offset = noise.get_noise_2d(0, shake_time) * shake_intensity
		
		shake_intensity = max(shake_intensity - shake_decay * delta, 0)
	else:
		h_offset = lerp(h_offset, 0.0, RETURN_TO_CENTER_SPEED * delta)
		v_offset = lerp(v_offset, 0.0, RETURN_TO_CENTER_SPEED * delta)
	

func screen_shake(intensity: int, time: float) -> void:
	randomize()
	noise.seed = randi()
	noise.frequency = DEFAULT_NOISE_FREQUENCY
	
	shake_intensity = intensity
	active_shake_time = time
	shake_time = 0
	shake_time_speed = DEFAULT_SHAKE_TIME_SPEED
