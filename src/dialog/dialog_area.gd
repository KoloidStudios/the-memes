extends Area2D

signal dialog_entered(did)

export var did: int = 1

var player: Player = null

func _on_Dialog_area_body_entered(body):
	if (body is Player):
		player = body
		$animation.play("popup")

func _on_Dialog_area_body_exited(body):
	if (player != null and body is Player):
		$animation.play_backwards("popup")
		player = null
		
func _process(delta):
	if (player != null and Input.is_action_just_pressed("ui_accept")):
		player = null
		print("Player entered dialog")
		$animation.play_backwards("popup")
		emit_signal("dialog_entered", did)
