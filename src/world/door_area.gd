extends Area2D

export (String, FILE, "*.tscn") var path_to_scene
export var pos:  Vector2
export var flip: bool

onready var tween: Tween = $tween

var current_scene: Node2D = null

func _ready():
	var root: Viewport = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene():
	# Avoid modifying root on interface level
	Global.goto_scene(current_scene, path_to_scene, pos, flip)

func _on_door_area_body_entered(body):
	if body.is_in_group("player"):
		tween.interpolate_property($canvas/black, "self_modulate:a", 0.0, 1.0, 0.35, Tween.TRANS_SINE, Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_completed")
		call_deferred("goto_scene")
