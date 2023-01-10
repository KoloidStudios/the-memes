extends Node2D
class_name BH_enemy

func _on_hitbox_body_entered(body):
	if body is BH_player:
		body.death()
