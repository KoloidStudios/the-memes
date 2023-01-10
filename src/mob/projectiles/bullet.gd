extends Area2D
class_name Bullet

export var speed: float = 10.0
export var delay_s: float = 0.0

onready var delay: Timer = $delay

var target: Node2D = null

func _ready():
	assert(delay != null)
	if (delay_s != 0.0):
		delay.start(delay_s)

var _timeout: bool = false
func _process(delta):
	if (!_timeout and target != null):
		self.look_at(target.position)
	else:
		position += transform.x * speed * delta

func _on_visibility_notifier_screen_exited():
	queue_free()

func _on_delay_timeout():
	_timeout = true
