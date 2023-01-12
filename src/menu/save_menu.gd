extends Control
class_name Save_menu

signal selected(id)
signal exited

var cont_mode: bool = false

func _ready():
	var file: File = File.new()
	if (cont_mode):
		if !file.file_exists("user://save1"):
			$base/container.get_node("1").disabled = true
		if !file.file_exists("user://save2"):
			$base/container.get_node("2").disabled = true
		if !file.file_exists("user://save3"):
			$base/container.get_node("3").disabled = true
		$base/container/back.grab_focus()
	else:
		$base/container.get_node("1").grab_focus()

func _on_1_pressed():
	emit_signal("selected", 1)

func _on_2_pressed():
	emit_signal("selected", 2)

func _on_3_pressed():
	emit_signal("selected", 3)

func _process(delta):
	if (Input.is_action_just_pressed("ui_cancel")):
		emit_signal("exited")
		queue_free()

func _on_back_pressed():
	emit_signal("exited")
	queue_free()
