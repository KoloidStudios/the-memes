extends Node

var save_system: Save_system = Save_system.new()

var stars:    int    = 0
var last_did: int    = 0
var last_cp:  String = ""

func goto_checkpoint():
	pass

func save():
	pass

func goto_scene(current_scene: Node2D, path_to_scene: String, pos: Vector2, flip: bool):
	current_scene.queue_free()
	var new_scene_res: PackedScene = load(path_to_scene)
	var new_scene: Node2D = new_scene_res.instance()
	if pos != Vector2.ZERO:
		var player: KinematicBody2D = new_scene.find_node("player")
		player.position = pos 
		player.get_node("skin").scale.x = -1 if flip else 1
	get_tree().get_root().add_child(new_scene)
	get_tree().set_current_scene(new_scene)
