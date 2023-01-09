extends Base_minigame

onready var purity:       ColorRect   = $sticky_layer/hud/base/bg_bar/purity_rect
onready var blue_crystal: TextureRect = $sticky_layer/hud/base/bg_bar/bluecrystal
onready var progress:     ProgressBar = $sticky_layer/hud/base/progress

func _ready() -> void:
	_started = true

func _max_y(ctrl: Control) -> float:
	return ctrl.rect_position.y + ctrl.rect_size.y

func _bc_in_purity() -> bool:
	if (purity.rect_position.y <= blue_crystal.rect_position.y and _max_y(blue_crystal) <= _max_y(purity)):
		return true
	elif (purity.rect_position.y < _max_y(purity) and blue_crystal.rect_position.y < purity.rect_position.y):
		return true
	elif (blue_crystal.rect_position.y < _max_y(purity) and _max_y(blue_crystal) > _max_y(purity)):
		return true
	else:
		return false

var _time:      float = 0.0
var _acc_speed: float = 4.0
var _sine_pos:  float = 0.0
func _process(delta) -> void:
	if (!_started): return
	
	_time += delta
	blue_crystal.rect_position.y = _sine_pos * 78 + 78
	
	_sine_pos = -cos(_time * _acc_speed)
	
	if (_bc_in_purity()):
		progress.value += 5 * delta
	
	if (Input.is_action_pressed("ui_accept")):
		purity.rect_position.y += 200 * delta
	else:
		purity.rect_position.y -= 200 * delta
	purity.rect_position.y = clamp(purity.rect_position.y, 0, 132)
