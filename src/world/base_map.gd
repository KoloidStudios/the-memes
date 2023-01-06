extends Node2D
class_name Base_map

onready var camera: Base_camera = get_node("camera")
onready var player: Player      = get_node("player")

onready var random: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	camera.set_focused(player)

var _pressed_cancel: bool = false
func _input(event: InputEvent) -> void:
	if (!_pressed_cancel and event.is_action_pressed("ui_cancel")):
		_pressed_cancel = true
		# Execute some pause menu
	elif (event.is_action_released("ui_cancel")):
		_pressed_cancel = false

# More power more wiggle wiggle wiggle
var _shake_power: float = 0.0
# Less decay last longer
var _shake_decay: float = 0.0
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("debug")):
		shake(60.0, 1.0)
	
	if (_shake_power > 0.0):
		_shake_power = lerp(_shake_power, 0, _shake_decay * delta)
		camera.offset = Vector2(
			random.randf_range(-_shake_power, _shake_power),
			random.randf_range(-_shake_power, _shake_power)
		)
	else:
		camera.offset = Vector2.ZERO
		_shake_power  = 0

func shake(power: float, decay: float) -> void:
	_shake_power = power
	_shake_decay = decay
