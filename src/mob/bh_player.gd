extends KinematicBody2D

const SPEED: float = 40.0
const MAX_SPEED: float = 200.0

var _motion: Vector2 = Vector2.ZERO

func _physics_process(delta):
	var shift_power: float = Input.get_action_strength("ui_shift")
	var x_input_power: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y_input_power: float = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if (abs(x_input_power) != 0):
		_motion.x += x_input_power * SPEED
		_motion.x = clamp(_motion.x, -MAX_SPEED + shift_power * 80, MAX_SPEED - shift_power * 80)
	else:
		_motion.x = lerp(_motion.x, 0, 0.5)

	if (abs(y_input_power) != 0):
		_motion.y += y_input_power * SPEED
		_motion.y = clamp(_motion.y, -MAX_SPEED + shift_power * 80, MAX_SPEED - shift_power * 80)
	else:
		_motion.y = lerp(_motion.y, 0, 0.5)
	
	_motion = move_and_slide(_motion)
