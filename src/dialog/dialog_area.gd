extends Area2D

signal dialog_entered(did)

export var did: int = 1

func _on_Dialog_area_body_entered(body):
	if (body is Player):
		print("Player entered dialog")
		emit_signal("dialog_entered", did)
