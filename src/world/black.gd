extends ColorRect

signal finished

onready var tween: Tween = $tween

func _init():
	color.a = 1.0
	
func _ready():
	tween.interpolate_property(self, "color:a", 1.0, 0.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func close():
	tween.interpolate_property(self, "color:a", 0.0, 1.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_tween_tween_all_completed():
	emit_signal("finished")
