extends Base_minigame
class_name Latto_latto

onready var accuracy_indicator: ColorRect = $sticky_layer/hud/base/accuracy/indicator
onready var accuracy: ProgressBar = $sticky_layer/hud/base/accuracy
onready var accuracy2: ProgressBar = $sticky_layer/hud/base/accuracy2
onready var progress: ProgressBar = $sticky_layer/hud/base/progress
onready var animation: AnimationPlayer = $animation
onready var anim_latto: AnimationPlayer = $latto/anim

func _ready():
	progress.self_modulate = Color(1, 1, 1, 1)
	$counter.self_modulate.a = 0.0
	animation.play("open")
	yield(animation, "animation_finished")
	animation.play("start")

var _change_speed: int = 5
var _acc_speed: int = 5
var _time: float = 0.0
var _sine_pos: float = -1.0
var _pressed: bool = false
func _process(delta):
	if (!_started): return
	$time_label.text = "0:"+String(ceil($timeout.time_left))
	
	_time += delta
	accuracy_indicator.rect_position.x = _sine_pos * 213 + 213
	
	if (progress.value < 20):
		_change_speed = 5
		accuracy.value = 35
#		accuracy2.value = 35
		anim_latto.play("play")
		
	elif (progress.value < 50):
		_change_speed = 8
		accuracy.value = 30
#		accuracy2.value = 30
		anim_latto.play("play")
		
	elif (progress.value < 60):
		_change_speed = 10
		accuracy.value = 25
#		accuracy2.value = 25
		anim_latto.play("play_combo", -1, 0.5)
		
	elif (progress.value < 80):
		_change_speed = 11
		accuracy.value = 20
#		accuracy2.value = 20
		anim_latto.play("play_combo", -1, 0.75)
	else:
		_change_speed = 12
		accuracy.value = 15
#		accuracy2.value = 15
		anim_latto.play("play_combo", -1, 1)
	
	if (progress.value > 0):
		progress.value -= 3 * delta
	
	if (((_sine_pos / 2) + 0.5) * 100 <= accuracy.value):
		_pressed = false
	
	if (Input.is_action_just_pressed("ui_accept")):
		if (!_pressed and (accuracy_indicator.rect_position.x * 100 / 426) <= accuracy.value):
			progress.value += 8
			_pressed = true
		else:
			$animation2.play("foul")
			shake(2, 20)
			progress.value -= 4
	
	_sine_pos = -cos(_time * _acc_speed)
	if (_change_speed != _acc_speed and accuracy_indicator.rect_position.x < 1):
		_time = 0
		_acc_speed = _change_speed
	
func start():
	_started = true

	
func restart():
	_restart = true
	animation.play_backwards("open")
	yield(animation, "animation_finished")
	_ready()

func _on_animation_animation_finished(anim_name):
	if (anim_name == "lose"):
		enter_confirm("Retry?", funcref(self, "restart"))
		yield(_active_confirm_menu, "confirmation_finished")
		if (!_restart):
			enter_confirm("Go to Checkpoint?", funcref(Global, "goto_checkpoint"))
	elif (anim_name == "win"):
		animation.play_backwards("open")
		

func _on_timeout_timeout():
	$time_label.text = "timeout"
	_started = false
	anim_latto.play("RESET")
	shake(20, 10)
	if (progress.value < 50):
		animation.play("lose")
	else:
		animation.play("win")
