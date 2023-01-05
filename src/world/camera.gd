extends Camera2D
class_name Base_camera

var _focused_node: Node2D = null

var _input_state: int = 1
func _process(delta):
	if (_focused_node == null):
		return

	# Don't center the player movement
	if (_focused_node is Player):
		var eval_vec: Vector2 = Vector2.ZERO
		if (_focused_node.input_power != 0):
			_input_state = _focused_node.input_power
		eval_vec.x = _input_state * 100 + _focused_node.position.x
		eval_vec.y = _focused_node.position.y
		position = lerp(position, eval_vec, 0.1)
	# Maybe if we want to focus on some object
	else:
		position = lerp(position, _focused_node.position, 0.1)

func set_focused(node: Node2D):
	_focused_node = node
