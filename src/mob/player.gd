extends Base_mob
class_name Player


const MOVE_SPEED: float = 20.0
const MAX_SPEED:  float = 200.0
const JUMP_POWER: float = 400.0

onready var footstep_sfx: AudioStreamPlayer = $step
var _footstep: bool = false
var _paused: bool = false

func _animate() -> void:
	# Flip the skin
	if (input_power != 0):
		$skin.scale.x = input_power
	
	if (abs(motion.y) < 1 and is_on_floor()):
		if (abs(motion.x) > 1 and input_power):
			$skin/anim.play("run")
			if !_footstep:
				$step_timer.start(0.25)
			_footstep = true
		else:
			_footstep = false
			$skin/anim.play("idle")

func play_footstep_sfx():
	if footstep_sfx.is_playing():
		return
	var random_pitch = (randf()/2)+0.75
	footstep_sfx.pitch_scale = random_pitch
	footstep_sfx.play()
	print("step")

var input_power: float
func _physics_process(delta):
	if _paused: return

	input_power = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	# --- Modify motion x value ---
	
	# If there's input power, give motion a power
	if (input_power != 0):
		motion.x += input_power * MOVE_SPEED
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	# If there's not input power and the player is still moving
	# decelerate the player body
	elif (abs(motion.x) > 1):
		motion.x = lerp(motion.x, 0, 0.2)
	else:
		motion.x = 0
	
	# --- Modify motion y value ---
	
	if (Input.is_action_just_pressed("jump")):
		jump(JUMP_POWER)
		$skin/anim.play("jump")
		
	# --- animate ---
	_animate()

func is_max_speed() -> bool:
	return abs(motion.x) == MAX_SPEED

func pause():
	_footstep = false
	$skin/anim.play("idle")
	motion = Vector2.ZERO
	_paused = true

func unpause():
	_paused = false

func _on_step_timer_timeout():
	if _footstep:
		$step.play()
		$step_timer.start(0.25)
