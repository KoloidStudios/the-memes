extends Node2D
class_name Base_map

onready var camera: Base_camera   = get_node("camera")
onready var player: Player        = get_node("player")
onready var dialog: Dialog_player = get_node("sticky_layer/dialog_player")

onready var random: RandomNumberGenerator = RandomNumberGenerator.new()
onready var Confirmation_menu := preload("res://src/menu/confirmation_menu.tscn")

func _ready() -> void:
	camera.set_focused(player)

var _pressed_cancel: bool = false
func _input(event: InputEvent) -> void:
	if (!_pressed_cancel and event.is_action_pressed("ui_cancel")):
		_pressed_cancel = true
		# Execute some pause menu
	elif (event.is_action_released("ui_cancel")):
		_pressed_cancel = false

# None to shake or shake to none
var _shake_raise: bool = false
# More power more wiggle wiggle wiggle
var _shake_power: float = 0.0
var _quake_power: float = 0.0
# Less decay last longer
var _shake_decay: float = 0.0
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("debug")):
		shake(10.0, 20.0) # Default hit shake
	
	if (_shake_power >= 1.0):
		if (_shake_raise):
			_shake_power = lerp(_shake_power, _quake_power, _shake_decay * delta)
		else:
			_shake_power = lerp(_shake_power, 0, _shake_decay * delta)
		
		if (_shake_power > (_quake_power - 1)):
			_shake_raise = false
			_quake_power = 0
		
		# Change camera offset to make shake effect
		camera.offset = Vector2(
			random.randf_range(-_shake_power, _shake_power),
			random.randf_range(-_shake_power, _shake_power)
		)
	else:
		camera.offset = Vector2.ZERO
		_shake_power  = 0

func shake(power: float, decay: float) -> void:
	_shake_raise = false
	_shake_power = power
	_shake_decay = decay

func quake(power: float, decay: float) -> void:
	_shake_raise = true
	_shake_power = 1.0
	_quake_power = power
	_shake_decay = decay

func enter_dialog(did: int):
	if (Global.last_did < did):
		Global.last_did = did
		player.pause()
		dialog.play_dialog(did)

func enter_confirm(text: String, callback: FuncRef):
	player.pause()
	var confirm: Confirmation_menu = Confirmation_menu.instance()
	confirm.connect("confirmation_finished", self, "_on_confirmation_finished")
	confirm.set_label(text)
	confirm.set_callback(callback)
	get_node("sticky_layer").add_child(confirm)

func _on_dialog_player_finished():
	player.unpause()

func _on_confirmation_finished():
	player.unpause()
