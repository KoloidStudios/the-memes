extends Control

signal play
signal cont
signal quit
signal credits

func _ready():
	$container/play_button.grab_focus()

func _on_play_button_pressed():
	print_debug("Pressed play button")
	emit_signal("play")
	$click.play()

func _on_continue_button_pressed():
	print_debug("Pressed continue button")
	emit_signal("cont")
	$click.play()

func _on_quit_button_pressed():
	print_debug("Pressed quit button")
	emit_signal("quit")
	$click.play()

func _on_credits_button_pressed():
	print_debug("Pressed credits button")
	emit_signal("credits")
	$click.play()
