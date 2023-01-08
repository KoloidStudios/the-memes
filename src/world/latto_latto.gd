extends Base_minigame
class_name Latto_latto

onready var accuracy_indicator: ColorRect = $sticky_layer/hud/base/accuracy/indicator
onready var accuracy: ProgressBar = $sticky_layer/hud/base/accuracy
onready var accuracy2: ProgressBar = $sticky_layer/hud/base/accuracy2
onready var progress: ProgressBar = $sticky_layer/hud/base/progress
onready var animation: AnimationPlayer = $animation

func _ready():
	animation.play("open")
	yield(animation, "animation_finished")
	animation.play("start")

var _change_speed: int = 5
var _acc_speed: int = 5
var _time: float = 0.0
var _sine_pos: float = 0.0
var _pressed: bool = false
func _process(delta):
	if (!_started): return
	$time_label.text = "0:"+String(floor($timeout.time_left))
	
	_time += delta
	accuracy_indicator.rect_position.x = _sine_pos * 213 + 213
	
	if (progress.value < 20):
		_change_speed = 5
		accuracy.value = 35
#		accuracy2.value = 35
	elif (progress.value < 40):
		_change_speed = 8
		accuracy.value = 30
#		accuracy2.value = 30
	elif (progress.value < 60):
		_change_speed = 10
		accuracy.value = 25
#		accuracy2.value = 25
	elif (progress.value < 80):
		_change_speed = 11
		accuracy.value = 20
#		accuracy2.value = 20
	else:
		_change_speed = 12
		accuracy.value = 15
#		accuracy2.value = 15
	
	if (progress.value > 0):
		progress.value -= 3 * delta
	
	if (((_sine_pos / 2) + 0.5) * 100 <= accuracy.value):
		_pressed = false
	
	if (Input.is_action_just_pressed("ui_accept")):
		if (!_pressed and (accuracy_indicator.rect_position.x * 100 / 426) <= accuracy.value):
			progress.value += 8
			_pressed = true
		else:
			animation.play("foul")
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

func _on_timeout_timeout():
	_started = false
	shake(20, 10)
	if (progress.value < 50):
		animation.play("lose")
	else:
		animation.play("win")
