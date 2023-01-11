extends KinematicBody2D
class_name BH_player

signal dead

const SPEED: float = 60.0
const MAX_SPEED: float = 200.0

var _motion: Vector2 = Vector2.ZERO

func _physics_process(delta):
	var shift_power: float = Input.get_action_strength("shift")
	var x_input_power: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y_input_power: float = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if (shift_power != 0):
		$hitbox/sprite.visible = true
	else:
		$hitbox/sprite.visible = false
	
	var vec: Vector2 = Vector2(x_input_power, y_input_power)
	var max_speed: Vector2 = (vec.normalized() * MAX_SPEED) - (vec.normalized() * shift_power * 120)
	if (abs(x_input_power) != 0):
		_motion.x += x_input_power * SPEED
		_motion.x = clamp(_motion.x, -abs(max_speed.x), abs(max_speed.x))
	else:
		_motion.x = lerp(_motion.x, 0, 0.8)

	if (abs(y_input_power) != 0):
		_motion.y += y_input_power * SPEED
		_motion.y = clamp(_motion.y, -abs(max_speed.y), abs(max_speed.y))
	else:
		_motion.y = lerp(_motion.y, 0, 0.8)
	
	_motion = move_and_slide(_motion)

func dead():
	emit_signal("dead")

func _on_hitbox_body_entered(body):
	dead()

func _on_hitbox_area_entered(area):
	if (area.is_in_group("projectiles")):
		dead()
