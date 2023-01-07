extends Control

signal play
signal cont
signal quit

func _ready():
	$container/play_button.grab_focus()

func _on_play_button_pressed():
	print_debug("Pressed play button")
	emit_signal("play")

func _on_continue_button_pressed():
	print_debug("Pressed continue button")
	emit_signal("cont")

func _on_quit_button_pressed():
	print_debug("Pressed quit button")
	emit_signal("quit")
