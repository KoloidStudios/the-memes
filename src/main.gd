extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Main_menu_play():
	get_tree().change_scene("res://src/world/test.tscn")

func _on_Main_menu_cont():
	pass # Replace with function body.

func _on_Main_menu_quit():
	get_tree().quit()
