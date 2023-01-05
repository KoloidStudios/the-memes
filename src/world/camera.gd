extends Camera2D
class_name Base_camera

var _focused_node: Node2D = null

var _eval_vec: Vector2 = Vector2.ZERO
func _process(delta):
	if (_focused_node == null):
		return

	# We don't really center the player movement
	if (_focused_node is Player):
		if (_focused_node.input_power != 0):
			_eval_vec.x = _focused_node.input_power * 40 + _focused_node.position.x
		
		_eval_vec.y = _focused_node.position.y
		position = lerp(position, _eval_vec, 0.1)
	# Maybe if we want to focus on some object
	else:
		position = lerp(position, _focused_node.position, 0.1)

func set_focused(node: Node2D):
	_focused_node = node
