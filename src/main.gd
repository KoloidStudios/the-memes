extends Node2D

func _ready():
	$Popup.visible = false
	$bgm.play()

onready var Save_menu: PackedScene = preload("res://src/menu/save_menu.tscn")

func _on_play(id):
	Global.save_system._index = id
	get_tree().change_scene("res://src/world/outdoor.tscn")

func _on_cont(id):
	Global.save_system._index = id
	Global.save_system.load_save(id)
	get_tree().change_scene(Global.last_cp)

func _on_save_exited():
	$Main_menu/NinePatchRect/container/play_button.grab_focus()

func _on_Main_menu_play():
	var save_menu := Save_menu.instance()
	save_menu.connect("selected", self, "_on_play")
	save_menu.connect("exited", self, "_on_save_exited")
	add_child(save_menu)

func _on_Main_menu_cont():
	var save_menu := Save_menu.instance()
	save_menu.cont_mode = true
	save_menu.connect("selected", self, "_on_cont")
	save_menu.connect("exited", self, "_on_save_exited")
	add_child(save_menu)

func _on_Main_menu_quit():
	get_tree().quit()

func _on_Main_menu_credits():
	$Popup.popup()

func _on_quit_button_pressed():
	$Popup.visible = false
