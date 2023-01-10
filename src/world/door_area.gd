extends Area2D

onready var tween: Tween = $tween
export(String, FILE, "*.tscn") var path_to_scene
export(Vector2) var pos
export(bool) var flip
var current_scene: Node2D = null

func _ready():
	var root: Viewport = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
#	if !get_parent().load_by_elev:
#		$canvas/black.self_modulate.a = 1
#		if !get_parent().pre_dialogue.empty() and Global.dialogue_index < get_parent().dialogue_index:
#			yield(get_parent(), "pre_dialogue_finished")
#		tween.interpolate_property($canvas/black, "self_modulate:a", 1.0, 0.0, 0.35, Tween.TRANS_SINE, Tween.EASE_OUT)
#		tween.start()

func goto_scene():
	current_scene.queue_free()
	var new_scene_res: PackedScene = load(path_to_scene)
	var new_scene: Node2D = new_scene_res.instance()
	if pos != Vector2.ZERO:
		var player: KinematicBody2D = new_scene.get_node("player").get_node("test_player")
		player.position = pos 
		player.get_node("sprite").flip_h = flip
	get_tree().get_root().add_child(new_scene)
	get_tree().set_current_scene(new_scene)

func _on_door_area_body_entered(body):
	if body.is_in_group("player"):
		print("entered")
		tween.interpolate_property($canvas/black, "self_modulate:a", 0.0, 1.0, 0.35, Tween.TRANS_SINE, Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_completed")
		call_deferred("goto_scene")
		for child in get_tree().root.get_children():
			if child.is_in_group("projectiles"):
				child.queue_free()
