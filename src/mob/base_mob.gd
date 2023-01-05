extends KinematicBody2D
class_name Base_mob

const GRAVITY: float = 20.0

var health: int

func _ready() -> void:
	pass

var motion: Vector2 = Vector2.ZERO # Basic motion
var snap:   Vector2 = Vector2.ZERO # Snap to moving platform
func _physics_process(delta) -> void:
	# Adds gravity
	motion.y += GRAVITY
	
	# Apply motion to body
	move_and_slide_with_snap(motion, snap, Vector2.UP, true, 4, 0.785398, false)

func die() -> void:
	pass

func spawn() -> void:
	pass
