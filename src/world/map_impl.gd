extends Node2D
class_name Test_impl

signal checkpoint
signal dialog_entered(did)

# Push to root node

func _on_dialog_entered(did):
	emit_signal("dialog_entered", did)

func _on_checkpoint():
	emit_signal("checkpoint")
