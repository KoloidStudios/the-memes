extends Node2D

func _on_Main_menu_play():
	get_tree().change_scene("res://src/world/outdoor.tscn")

func _on_Main_menu_cont():
	pass # Replace with function body.

func _on_Main_menu_quit():
	get_tree().quit()
