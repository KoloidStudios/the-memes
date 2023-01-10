extends Control
class_name Pause_menu

signal cont
signal quit

func _ready():
	$body/container/continue.grab_focus()

func _on_continue_pressed():
	print_debug("continue")
	emit_signal("cont")
	queue_free()

func _on_quit_pressed():
	print_debug("quit")
	emit_signal("quit")
	queue_free()
