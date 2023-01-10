extends Camera2D
class_name Base_camera

var _focused_node: Node2D = null

func _process(delta):
	if (_focused_node == null):
		return
	
	# Meh
	position = lerp(position, _focused_node.position, 0.1)

func set_focused(node: Node2D):
	_focused_node = node
