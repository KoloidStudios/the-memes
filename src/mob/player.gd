extends Base_mob
class_name Player

const MOVE_SPEED: float = 20.0
const MAX_SPEED:  float = 200.0
const JUMP_POWER: float = 400.0

var xp: int
var level: int

func _ready():
	pass # Replace with function body.

var input_power: float
func _physics_process(delta):
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
		
func is_max_speed() -> bool:
	return abs(motion.x) == MAX_SPEED
