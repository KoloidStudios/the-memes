extends Area2D

signal door_entered
export (String, FILE, "*.tscn") var scene
var current_scene: Node2D = null

func goto_scene():
	current_scene.queue_free()
	var new_scene_res: PackedScene = load(scene)
	var new_scene: Node2D = new_scene_res.instance()
	get_tree().get_root().add_child(new_scene)
	get_tree().set_current_scene(new_scene)

func _ready():
	assert(scene != null)
	var root: Viewport = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func _on_Door_area_body_entered(body):
	call_deferred("goto_scene")
