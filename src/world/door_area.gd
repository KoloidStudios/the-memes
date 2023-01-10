extends Area2D

export (String, FILE, "*.tscn") var path_to_scene
export var pos:  Vector2
export var flip: bool

signal change_scene(fn)

var current_scene: Node2D = null

func _ready():
	var root: Viewport = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene():
	# Avoid modifying root on interface level
	Global.call_deferred("goto_scene", current_scene, path_to_scene, pos, flip)

func _on_door_area_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("change_scene", funcref(self, "goto_scene"))
