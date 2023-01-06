extends Area2D

export var did: int = 1
onready var _world: Node2D = get_parent()

func _on_Dialog_area_body_entered(body):
	if (body is Player):
		print("Player entered dialog")
		_world.enter_dialog(did)
