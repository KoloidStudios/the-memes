extends Node2D
class_name Base_map

func _ready() -> void:
	var camera: Base_camera = get_node("camera")
	var player: Player      = get_node("player")
	camera.set_focused(player)

var _pressed_cancel: bool = false
func _input(event: InputEvent) -> void:
	if (!_pressed_cancel and event.is_action_pressed("ui_cancel")):
		_pressed_cancel = true
		# Execute some pause menu
	elif (event.is_action_released("ui_cancel")):
		_pressed_cancel = false
