extends Node2D

onready var label:    Label           = $skin/label
onready var anim:     AnimationPlayer = $skin/anim

func _ready():
	anim.play("idle")

func _on_dialog_area_body_entered(body):
	label.percent_visible == 100
