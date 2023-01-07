extends Control
class_name Confirmation_menu

signal confirmation_finished

onready var _label: Label = get_node("window/label")

var _label_text: String
var _callback:   FuncRef

func _ready():
	$window/container/yes.grab_focus()
	_label.text = _label_text

func set_label(text: String) -> void:
	_label_text = text

func set_callback(callback: FuncRef):
	_callback = callback

func _on_yes_pressed() -> void:
	_callback.call_func()
	quit()

func _on_no_pressed() -> void:
	quit()

func quit() -> void:
	emit_signal("confirmation_finished")
	queue_free()
