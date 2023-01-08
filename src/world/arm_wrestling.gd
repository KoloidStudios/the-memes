extends Base_minigame
class_name Arm_wrestling

onready var progress: ProgressBar = $sticky_layer/hud/base/progress
onready var animation: AnimationPlayer = $animation

var _started: bool = false
var _win:     bool = false

func _ready():
	animation.play("start")

func _process(delta):
	if (!_started): return
	if (progress.value <= 0):
		_started = false
		return
	if (progress.value >= 100):
		_win = true
		_started = false
		return
	
	progress.value -= 30 * delta
	
	if (Input.is_action_just_pressed("ui_accept")):
		progress.value += 5
	
func start():
	_started = true

func restart():
	pass
