extends Area2D

signal achievement

onready var _popup_animation: AnimationPlayer = $popup/animation

var _confirm_lock: bool = false
var _anim_ended:   bool = false

var _player: Player = null

func _process(delta):
	if (_player and !_confirm_lock and Input.is_action_just_pressed("ui_accept")):
		_confirm_lock = true
		_anim_ended = true
		_popup_animation.play("end")
		emit_signal("achievement")

func _on_Achievement_body_entered(body):
	if (body is Player):
		_anim_ended = false
		_player = body
		_popup_animation.play("start")


func _on_Achievement_body_exited(body):
	if (body is Player):
		_player = null
		if !_anim_ended:
			_popup_animation.play("end")
		_confirm_lock = false
