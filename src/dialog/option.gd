extends NinePatchRect
class_name Option

signal clicked(slot)

var slot: String

func _on_button_pressed():
	emit_signal("clicked", slot)

func set_text(new_text: String):
	$button.text = new_text
