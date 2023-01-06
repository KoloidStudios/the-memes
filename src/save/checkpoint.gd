extends Area2D

onready var _popup_animation: AnimationPlayer = $popup/animation
onready var _world: Node2D = get_parent()

var _player: Player = null

func _on_Checkpoint_body_entered(body):
	if (body is Player):
		_player = body
		_popup_animation.play("start")

func _on_Checkpoint_body_exited(body):
	if (body is Player):
		_player = null
		_popup_animation.play("end")

func _process(delta):
	if (Input.is_action_just_pressed("ui_accept")):
		print(_world.filename)
		pass
