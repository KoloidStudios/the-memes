extends Node

var save_system: Save_system = Save_system.new()

var stars:    int    = 0
var last_cp:  String = ""

var dids: Dictionary = {}

var current_scene: Node2D = null

func update_current_scene():
	var root: Viewport = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_checkpoint():
	pass

func save():
	pass

func goto_scene(path_to_scene: String, pos: Vector2, flip: bool):
	current_scene.queue_free()
	var new_scene_res: PackedScene = load(path_to_scene)
	var new_scene: Node2D = new_scene_res.instance()
	if pos != Vector2.ZERO:
		var player: KinematicBody2D = new_scene.find_node("player")
		player.position = pos 
		player.get_node("skin").scale.x = -1 if flip else 1
	get_tree().get_root().add_child(new_scene)
	get_tree().set_current_scene(new_scene)

func enter_bullet_hell(obj: Dialog_player):
	yield(obj, "finished")
	goto_scene("res://src/world/bullet_hell.tscn", Vector2.ZERO, false)
	
func enter_making_meth(obj: Dialog_player):
	yield(obj, "finished")
	goto_scene("res://src/world/making_meth.tscn", Vector2.ZERO, false)
