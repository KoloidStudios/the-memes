extends NinePatchRect
class_name Option

signal clicked(slot)

var slot: String

func _on_button_pressed():
	print_debug("pressed")
	emit_signal("clicked", int(slot))

func set_text(new_text: String):
	$container/button.text = new_text

func focus():
	$container/button.grab_focus()
