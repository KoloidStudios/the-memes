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
		shake(10, 20)
		_started = false
		animation.play("lose")
		return
	if (progress.value >= 100):
		shake(10, 20)
		_win = true
		_started = false
		animation.play("win")
		return
	
	progress.value -= 30 * delta
	
	if (Input.is_action_just_pressed("ui_accept")):
		shake(2, 20)
		progress.value += 5
	
func start():
	_started = true

func restart():
	print_debug("restarted")

func _on_animation_animation_finished(anim_name):
	if (anim_name == "lose"):
		enter_confirm("Retry?", funcref(self, "restart"))
