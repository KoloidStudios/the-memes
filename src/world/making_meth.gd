extends Base_minigame

onready var purity:       ColorRect   = $sticky_layer/hud/base/bg_bar/purity_rect
onready var blue_crystal: TextureRect = $sticky_layer/hud/base/bg_bar/bluecrystal
onready var progress:     ProgressBar = $sticky_layer/hud/base/progress
onready var fx: CPUParticles2D        = $fx

onready var timeout: Timer = $timeout
onready var time_label: Label = $sticky_layer/hud/base/timer

onready var animation: AnimationPlayer = $animation
onready var tween: Tween = $tween
var _stop_played: bool = false
func _ready() -> void:
	$label.self_modulate.a = 0.0
	animation.play("open")
	yield(animation, "animation_finished")
	animation.play("start")

func _max_y(ctrl: Control) -> float:
	return ctrl.rect_position.y + ctrl.rect_size.y

func _bc_in_purity() -> bool:
	if (purity.rect_position.y <= blue_crystal.rect_position.y and _max_y(blue_crystal) <= _max_y(purity)):
		return true
	elif (purity.rect_position.y < _max_y(blue_crystal) and blue_crystal.rect_position.y < purity.rect_position.y):
		return true
	elif (blue_crystal.rect_position.y < _max_y(purity) and _max_y(blue_crystal) > _max_y(purity)):
		return true
	else:
		return false

var _backsound_played: bool = false

var _score: int = 0
var _trial: int = 0

var _time:      float = 0.0
var _acc_speed: float = 4.0
var _sine_pos:  float = -1.0
func _process(delta) -> void:
	if (!_started): return
	
	if (!_backsound_played):
		_backsound_played = true
		$backsound.play()
	
	var shader: ShaderMaterial = $sticky_layer/black.material
	time_label.text = "0:"+String(ceil($timeout.time_left))
	
	_time += delta
	blue_crystal.rect_position.y = _sine_pos * 78 + 78
	
	_sine_pos = -cos(_time * _acc_speed)
	
	if (_bc_in_purity()):
		progress.value += 10 * delta
		$fx/anim.play("play")
		_stop_played = false
	else:
		progress.value -= 5 * delta
		if (!_stop_played):
			$fx/anim.play("stop")
		_stop_played = true
	
	if (Input.is_action_pressed("ui_accept")):
		purity.rect_position.y += 250 * delta
	else:
		purity.rect_position.y -= 250 * delta
	purity.rect_position.y = clamp(purity.rect_position.y, 0, 132)
	
	if (progress.value >= 100):
		_started = false
		_trial += 1
		_score += 1
		shake(10, 20)
		$timeout.stop()
		tween.interpolate_property(blue_crystal, "rect_position", blue_crystal.rect_position, Vector2(-97, -1), 0.5, Tween.TRANS_CIRC, Tween.EASE_OUT)
		tween.interpolate_property(blue_crystal, "self_modulate:a", 1.0, 0.0, 0.5, Tween.TRANS_CIRC, Tween.EASE_OUT)
		tween.interpolate_property(purity, "rect_position:y", purity.rect_position.y, 0, 0.5, Tween.TRANS_CIRC, Tween.EASE_OUT)
		tween.start()
		animation.play("get_one")

func _eval_score():
	$backsound.stop()
	$fx/anim.play("stop")
	if (_score == 0):
		animation.play("lose")
	else:
		animation.play("win")
		
func update_score() -> void:
	$sticky_layer/hud/base/bc_label.text = "Total: " + String(_score)

func start() -> void:
	if (_trial == 3):
		_eval_score()
		return
	_time = 0
	_sine_pos = -1.0
	$timeout.start(20)
	_started = true

func restart():
	_trial = 0
	_score = 0
	_restart = true
	animation.play_backwards("open")
	yield(animation, "animation_finished")
	_ready()

func _on_animation_animation_finished(anim_name):
	if (anim_name == "lose"):
		enter_confirm("Retry?", funcref(self, "restart"))
		yield(_active_confirm_menu, "confirmation_finished")
		if (!_restart):
			animation.play_backwards("open")
			yield(animation, "animation_finished")
			Global.goto_scene("res://src/world/morioh.tscn", Vector2(512, 221), false)
		else:
			_restart = false
	elif (anim_name == "win"):
		animation.play_backwards("open")
		yield(animation, "animation_finished")
		Global.goto_scene("res://src/world/morioh.tscn", Vector2(512, 221), false)

func _on_timeout_timeout():
	if (_started):
		time_label.text = "timeout"
		_trial += 1
		_started = false
		shake(10, 20)
		tween.interpolate_property(blue_crystal, "rect_position:y", blue_crystal.rect_position.y, 156, 0.5, Tween.TRANS_CIRC, Tween.EASE_OUT)
		tween.interpolate_property(blue_crystal, "self_modulate:a", 1.0, 0.0, 0.5, Tween.TRANS_CIRC, Tween.EASE_OUT)
		tween.interpolate_property(purity, "rect_position:y", purity.rect_position.y, 0, 0.5, Tween.TRANS_CIRC, Tween.EASE_OUT)
		tween.start()
		animation.play("foul")

func _on_backsound_finished():
	if (_started):
		_backsound_played = false
