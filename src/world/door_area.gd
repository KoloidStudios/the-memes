extends Area2D

export (String, FILE, "*.tscn") var path_to_scene
export var pos:  Vector2 = Vector2.ZERO
export var flip: bool = false
export var manual: bool = false

onready var _popup_animation: AnimationPlayer = $popup/animation

var player: Player = null

signal change_scene(fn)

var _pressed: bool = false
func _process(delta):
	if !manual: return
	if player != null and Input.is_action_just_pressed("ui_accept") and !_pressed:
		_popup_animation.play("end")
		_pressed = true
		emit_signal("change_scene", funcref(self, "goto_scene"))

func goto_scene():
	# Avoid modifying root on interface level
	Global.call_deferred("goto_scene", path_to_scene, pos, flip)

func _on_door_area_body_entered(body):
	if body is Player:
		if manual:
			print("noice")
			player = body
			_popup_animation.play("start")
		else:
			emit_signal("change_scene", funcref(self, "goto_scene"))

func _on_door_area_body_exited(body):
	if body is Player:
		if manual:
			player = null
			_popup_animation.play("end")
