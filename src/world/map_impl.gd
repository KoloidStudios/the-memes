extends Node2D
class_name Test_impl

signal checkpoint
signal dialog_entered(did)
signal change_scene(fn)
signal achievement_popup

# Push to root node

func _on_dialog_entered(did):
	emit_signal("dialog_entered", did)

func _on_checkpoint():
	emit_signal("checkpoint")

func _on_change_scene(fn):
	emit_signal("change_scene", fn)

func _on_achievement_popup():
	emit_signal("achievement_popup")

func ready() -> void:
	get_viewport().connect("gui_focus_changed", self, "_on_focus_changed")
	
func _on_focus_changed(control: Control) -> void:
	if control != null:
		print(control.name)
